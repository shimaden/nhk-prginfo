# coding: utf-8

# Original authoer: Chisa Youzaka
# Original source : https://github.com/youzaka/ariblib/blob/master/ariblib/constants.py
# Original License: MIT


# 定数定義

# ARIB-STD-B10-2-H コンテント記述子におけるジャンル指定
CONTENT_TYPE = {
  0x00 => {
    :genre => 'ニュース／報道',
    :subgenre => {
      0x00 => '定時・総合',
      0x01 => '天気',
      0x02 => '特集・ドキュメント',
      0x03 => '政治・国会',
      0x04 => '経済・市況',
      0x05 => '海外・国際',
      0x06 => '解説',
      0x07 => '討論・会談',
      0x08 => '報道特番',
      0x09 => 'ローカル・地域',
      0x0A => '交通',
      0x0F => 'その他',
    }
  },
  0x01 => {
    :genre => 'スポーツ',
    :subgenre => {
      0x00 => 'スポーツニュース',
      0x01 => '野球',
      0x02 => 'サッカー',
      0x03 => 'ゴルフ',
      0x04 => 'その他の球技',
      0x05 => '相撲・格闘技',
      0x06 => 'オリンピック・国際大会',
      0x07 => 'マラソン・陸上・水泳',
      0x08 => 'モータースポーツ',
      0x09 => 'マリン・ウィンタースポーツ',
      0x0A => '競馬・公営競技',
      0x0F => 'その他',
    }
  },
  0x02 => {
    :genre => '情報／ワイドショー',
    :subgenre => {
      0x00 => '芸能・ワイドショー',
      0x01 => 'ファッション',
      0x02 => '暮らし・住まい',
      0x03 => '健康・医療',
      0x04 => 'ショッピング・通販',
      0x05 => 'グルメ・料理',
      0x06 => 'イベント',
      0x07 => '番組紹介・お知らせ',
      0x0F => 'その他',
    }
  },
  0x03 => {
    :genre => 'ドラマ',
    :subgenre => {
      0x00 => '国内ドラマ',
      0x01 => '海外ドラマ',
      0x02 => '時代劇',
      0x0F => 'その他',
    }
  },
  0x04 => {
    :genre => '音楽',
    :subgenre => {
      0x00 => '国内ロック・ポップス',
      0x01 => '海外ロック・ポップス',
      0x02 => 'クラシック・オペラ',
      0x03 => 'ジャズ・フュージョン',
      0x04 => '歌謡曲・演歌',
      0x05 => 'ライブ・コンサート',
      0x06 => 'ランキング・リクエスト',
      0x07 => 'カラオケ・のど自慢',
      0x08 => '民謡・邦楽',
      0x09 => '童謡・キッズ',
      0x0A => '民族音楽・ワールドミュージック',
      0x0F => 'その他',
    }
  },
  0x05 => {
    :genre => 'バラエティ',
    :subgenre => {
      0x00 => 'クイズ',
      0x01 => 'ゲーム',
      0x02 => 'トークバラエティ',
      0x03 => 'お笑い・コメディ',
      0x04 => '音楽バラエティ',
      0x05 => '旅バラエティ',
      0x06 => '料理バラエティ',
      0x0F => 'その他',
    }
  },
  0x06 => {
    :genre => '映画',
    :subgenre => {
      0x00 => '洋画',
      0x01 => '邦画',
      0x02 => 'アニメ',
      0x0F => 'その他',
    }
  },
  0x07 => {
    :genre => 'アニメ／特撮',
    :subgenre => {
      0x00 => '国内アニメ',
      0x01 => '海外アニメ',
      0x02 => '特撮',
      0x0F => 'その他',
    }
  },
  0x08 => {
    :genre => 'ドキュメンタリー／教養',
    :subgenre => {
      0x00 => '社会・時事',
      0x01 => '歴史・紀行',
      0x02 => '自然・動物・環境',
      0x03 => '宇宙・科学・医学',
      0x04 => 'カルチャー・伝統文化',
      0x05 => '文学・文芸',
      0x06 => 'スポーツ',
      0x07 => 'ドキュメンタリー全般',
      0x08 => 'インタビュー・討論',
      0x0F => 'その他',
    }
  },
  0x09 => {
    :genre => '劇場／公演',
    :subgenre => {
      0x00 => '現代劇・新劇',
      0x01 => 'ミュージカル',
      0x02 => 'ダンス・バレエ',
      0x03 => '落語・演芸',
      0x04 => '歌舞伎・古典',
      0x0F => 'その他',
    }
  },
  0x0A => {
    :genre => '趣味／教育',
    :subgenre => {
      0x00 => '旅・釣り・アウトドア',
      0x01 => '園芸・ペット・手芸',
      0x02 => '音楽・美術・工芸',
      0x03 => '囲碁・将棋',
      0x04 => '麻雀・パチンコ',
      0x05 => '車・オートバイ',
      0x06 => 'コンピュータ・ＴＶゲーム',
      0x07 => '会話・語学',
      0x08 => '幼児・小学生',
      0x09 => '中学生・高校生',
      0x0A => '大学生・受験',
      0x0B => '生涯教育・資格',
      0x0C => '教育問題',
      0x0F => 'その他',
    }
  },
  0x0B => {
    :genre => '福祉',
    :subgenre => {
      0x00 => '高齢者',
      0x01 => '障害者',
      0x02 => '社会福祉',
      0x03 => 'ボランティア',
      0x04 => '手話',
      0x05 => '文字（字幕）',
      0x06 => '音声解説',
      0x0F => 'その他',
    }
  },
  0x0E => {
    :genre => '拡張',
    :subgenre => {
      0x00 => 'BS/地上デジタル放送用番組付属情報',
      0x01 => '広帯域CS デジタル放送用拡張',
      0x02 => '衛星デジタル音声放送用拡張',
      0x03 => 'サーバー型番組付属情報',
      0x04 => 'IP 放送用番組付属情報',
    }
  },
  0x0F => {
    :genre => 'その他',
    :subgenre => {
      0x0F => 'その他',
    }
  }
}

if $0 == __FILE__ then
  puts(CONTENT_TYPE[0x0B][:genre])
  puts(CONTENT_TYPE[0x0B][:subgenre][0x02])
end

