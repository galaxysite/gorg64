unit lnglist;

{$MODE OBJFPC}
{$RANGECHECKS ON}
{$GOTO ON}
{$CODEPAGE UTF8}
{$ASMMODE INTEL}

{
    Locales list.
    For GNU/Linux.
    Version: 1.
    Written on FreePascal (https://freepascal.org/).
    Copyright (C) 2024  Artyomov Alexander
    http://self-made-free.ru/
    aralni@mail.ru

    This program is free software: you can redistribute it and/or modify
    it under the terms of the GNU Affero General Public License as
    published by the Free Software Foundation, either version 3 of the
    License, or (at your option) any later version.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU Affero General Public License for more details.

    You should have received a copy of the GNU Affero General Public License
    along with this program.  If not, see <https://www.gnu.org/licenses/>.
}

interface

const
MAX_LANGS=130;

locales_s : array[0..MAX_LANGS] of utf8string = (
'C',
'POSIX',
'af_ZA',
'ar_AE',
'ar_BH',
'ar_DZ',
'ar_EG',
'ar_IQ',
'ar_JO',
'ar_KW',
'ar_LY',
'ar_MA',
'ar_OM',
'ar_QA',
'ar_SA',
'ar_TN',
'ar_YE',
'as_IN',
'az_AZ',
'be_BY',
'bg_BG',
'bn_IN',
'bs_BA',
'ca_ES',
'cs_CZ',
'da_DK',
'de_AT',
'de_BE',
'de_CH',
'de_DE',
'de_LI',
'de_LU',
'el_CY',
'el_GR',
'en_AU',
'en_BW',
'en_CA',
'en_GB',
'en_HK',
'en_IE',
'en_IN',
'en_MT',
'en_NZ',
'en_PH',
'en_SG',
'en_US',
'en_ZW',
'es_AR',
'es_BO',
'es_CL',
'es_CO',
'es_CR',
'es_DO',
'es_EC',
'es_ES',
'es_GT',
'es_HN',
'es_MX',
'es_NI',
'es_PA',
'es_PE',
'es_PR',
'es_PY',
'es_SV',
'es_US',
'es_UY',
'es_VE',
'et_EE',
'fi_FI',
'fr_BE',
'fr_CA',
'fr_CH',
'fr_FR',
'fr_LU',
'gu_IN',
'he_IL',
'hi_IN',
'hr_HR',
'hu_HU',
'hy_AM',
'id_ID',
'is_IS',
'it_CH',
'it_IT',
'ja_JP',
'ka_GE',
'kk_KZ',
'kn_IN',
'ko_KR',
'ks_IN',
'ku_TR',
'ku_TR@sorani',
'ky_KG',
'lt_LT',
'lv_LV',
'mk_MK',
'ml_IN',
'mr_IN',
'ms_MY',
'mt_MT',
'nb_NO',
'nl_BE',
'nl_NL',
'nn_NO',
'or_IN',
'pa_IN',
'pl_PL',
'pt_BR',
'pt_PT',
'ro_RO',
'ru_RU',
'ru_UA',
'sa_IN',
'sk_SK',
'sl_SI',
'sq_AL',
'sr_ME',
'sr_ME@latin',
'sr_RS',
'sr_RS@latin',
'sv_SE',
'ta_IN',
'te_IN',
'th_TH',
'tr_TR',
'uk_UA',
'vi_VN',
'zh_CN',
'zh_HK',
'zh_SG',
'zh_TW'
);

locales_n : array[0..MAX_LANGS] of utf8string = (
'C, POSIX',
'C, POSIX',
'Afrikaans, South Africa',
'Arabic, United Arab Emirates',
'Arabic, Bahrain',
'Arabic, Algeria',
'Arabic, Egypt',
'Arabic, Iraq',
'Arabic, Jordan',
'Arabic, Kuwait',
'Arabic, Libya',
'Arabic, Morocco',
'Arabic, Oman',
'Arabic, Qatar',
'Arabic, Saudi Arabia',
'Arabic, Tunisia',
'Arabic, Yemen',
'Assamese, India',
'Azerbaijani, Azerbaijan',
'Belarusian, Belarus',
'Bulgarian, Bulgaria',
'Bengali, India',
'Bosnian, Bosnia and Herzegovina',
'Catalan, Spain',
'Czech, Czech Republic',
'Danish, Denmark',
'German, Austria',
'German, Belgium',
'German, Switzerland',
'German, Germany',
'German, Liechtenstein',
'German, Luxembourg',
'Greek, Cyprus',
'Greek, Greece',
'English, Australia',
'English, Botswana',
'English, Canada',
'English, United Kingdom',
'English, Hong Kong SAR China',
'English, Ireland',
'English, India',
'English, Malta',
'English, New Zealand',
'English, Philippines',
'English, Singapore',
'English, U.S.A.',
'English, Zimbabwe',
'Spanish, Argentina',
'Spanish, Bolivia',
'Spanish, Chile',
'Spanish, Colombia',
'Spanish, Costa Rica',
'Spanish, Dominican Republic',
'Spanish, Ecuador',
'Spanish, Spain',
'Spanish, Guatemala',
'Spanish, Honduras',
'Spanish, Mexico',
'Spanish, Nicaragua',
'Spanish, Panama',
'Spanish, Peru',
'Spanish, Puerto Rico',
'Spanish, Paraguay',
'Spanish, El Salvador',
'Spanish, U.S.A.',
'Spanish, Uruguay',
'Spanish, Venezuela',
'Estonian, Estonia',
'Finnish, Finland',
'French, Belgium',
'French, Canada',
'French, Switzerland',
'French, France',
'French, Luxembourg',
'Gujarati, India',
'Hebrew, Israel',
'Hindi, India',
'Croatian, Croatia',
'Hungarian, Hungary',
'Armenian, Armenia',
'Indonesian, Indonesia',
'Icelandic, Iceland',
'Italian, Switzerland',
'Italian, Italy',
'Japanese, Japan',
'Georgian, Georgia',
'Kazakh, Kazakhstan',
'Kannada, India',
'Korean, Korea',
'Kashmiri, India',
'Kurdish, Turkey',
'Kurdish (Sorani), Turkey',
'Kirghiz, Kyrgyzstan',
'Lithuanian, Lithuania',
'Latvian, Latvia',
'Macedonian, Macedonia',
'Malayalam, India',
'Marathi, India',
'Malay, Malaysia',
'Maltese, Malta',
'Bokmal, Norway',
'Dutch, Belgium',
'Dutch, Netherlands',
'Nynorsk, Norway',
'Oriya, India',
'Punjabi, India',
'Polish, Poland',
'Portuguese, Brazil',
'Portuguese, Portugal',
'Romanian, Romania',
'Russian, Russia',
'Russian, Ukraine',
'Sanskrit, India',
'Slovak, Slovakia',
'Slovenian, Slovenia',
'Albanian, Albania',
'Serbian, Montenegro',
'Serbian, Montenegro (Latin)',
'Serbian, Serbia',
'Serbian, Serbia (Latin)',
'Swedish, Sweden',
'Tamil, India',
'Telugu, India',
'Thai, Thailand',
'Turkish, Turkey',
'Ukrainian, Ukraine',
'Vietnamese, Vietnam',
'Simplified Chinese, China',
'Traditional Chinese, Hong Kong SAR China',
'Chinese, Singapore',
'Traditional Chinese, Taiwan'
);

implementation

end.