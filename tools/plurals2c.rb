#!/usr/bin/ruby
#  Convert CLDR plural rules into C function.
#  See http://cldr.unicode.org/index/cldr-spec/plural-rules
#  Author: Pavel Ivashkov, 2012-02-24.
#  Copyright (c) 2012 Smartling. All rights reserved.
require 'rubygems'
require 'mustache'
require 'nokogiri'
require 'parser.rb'

module Gen

class PluralRules
  def initialize
    @p = PluralRulesParser.new
  end

  def parse_xml(fn)
    doc = Nokogiri::XML(open(fn,'r'))
    r = doc.xpath('//pluralRules')
    r = Hash[ r.map{|x| [x['locales'], Hash[x.elements.map{|y| [y['count'], y.inner_text]} ]]} ]
    r.update(r){|k,v| v.map{|a,b| {:name => a, :metacode => b, :ccode => rule2c(b)}}.sort{|a,b| a[:metacode].size <=> b[:metacode].size} }
    r.reject!{|k,v| v.size <= 0}
    i = 0
    r = r.map{|k,v|
      i += 1
      n = 'set' + i.to_s
      l = k.split.map{|x| {:name => x, :code => x.unpack('H*')[0]}}.sort{|a,b| a[:code].to_i(16) <=> b[:code].to_i(16)}
      {:setname => n, :langs => l, :forms => v}
    }
  end

  def rule2c(s)
    v = @p.parse(s.downcase)
    raise "\"#{s}\" #{@p.failure_reason}" unless v
    return v.value
  end
end

class Gen2C
  def generate(rules)
    frules = rules.map{|x| x.merge(:forms => x[:forms].reject{|y| not y[:metacode].include?('within')}) }
    frules.reject!{|x| x[:forms].size <= 0 }

    tpl =<<-EOL
//
//  pluralform.c
//  Smartling.i18n
//
//  Originally created by Pavel Ivashkov on 2012-02-24.
//  Copyright (c) 2012 Smartling. All rights reserved.
//
const char* pluralform(const char* lang, int n);
const char* pluralformf(const char* lang, float n);

// Generated from CLDR Version 21
// http://unicode.org/cldr/trac/browser/tags/release-21/common/supplemental/plurals.xml
// http://unicode.org/repos/cldr-tmp/trunk/diff/supplemental/language_plural_rules.html
const char* pluralformf(const char* lang, float n)
{
	if (n == (int)n) {
		return pluralform(lang, (int)n);
	}

	if (!lang)
		return "other";

	unsigned int lc = 0;
	for (; *lang; lang++) { lc = (lc << 8) + *lang; }

	switch (lc) {
{{#frules}}

	// {{setname}}
	{{#langs}}
	case 0x{{code}}: // {{name}}
	{{/langs}}
	{{#forms}}
		if ({{&ccode}}) // {{metacode}}
			return "{{name}}";
	{{/forms}}
		break;
{{/frules}}
	}

	return "other";
}

const char* pluralform(const char* lang, int n)
{
	if (!lang)
		return "other";

	unsigned int lc = 0;
	for (; *lang; lang++) { lc = (lc << 8) + *lang; }

	switch (lc) {
{{#rules}}

	// {{setname}}
	{{#langs}}
	case 0x{{code}}: // {{name}}
	{{/langs}}
	{{#forms}}
		if ({{&ccode}}) // {{metacode}}
			return "{{name}}";
	{{/forms}}
		break;
{{/rules}}
	}

	return "other";
}
EOL

    Mustache.render(tpl, { :rules => rules, :frules => frules })
  end
end

end

fn = ARGV[0]
p = Gen::PluralRules.new
rules = p.parse_xml(fn)
g = Gen::Gen2C.new
puts g.generate(rules)

