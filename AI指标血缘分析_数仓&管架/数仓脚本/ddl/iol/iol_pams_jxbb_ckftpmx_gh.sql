/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol pams_jxbb_ckftpmx_gh
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.pams_jxbb_ckftpmx_gh
whenever sqlerror continue none;
drop table ${iol_schema}.pams_jxbb_ckftpmx_gh purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.pams_jxbb_ckftpmx_gh(
    tjrq number(22,0) -- 统计日期
    ,jxdxdh number(22,0) -- 绩效对象代号
    ,khdxdh number(22,0) -- 考核对象代号
    ,zhhm varchar2(750) -- 账户户名
    ,zhdh varchar2(75) -- 账号代号
    ,zzh varchar2(75) -- 子账号
    ,zhbs varchar2(3) -- 账户标识
    ,kh varchar2(150) -- 卡号
    ,khh varchar2(150) -- 客户号
    ,khjgdh varchar2(75) -- 开户机构代号
    ,khjgmc varchar2(150) -- 开户机构名称
    ,gsjgdh varchar2(75) -- 归属机构代号
    ,gsjgmc varchar2(150) -- 归属机构名称
    ,khjlgh varchar2(150) -- 客户经理工号
    ,khjlxm varchar2(150) -- 客户经理姓名
    ,fpbl number(19,5) -- 分配比例
    ,kmh varchar2(75) -- 科目号
    ,kmmc varchar2(150) -- 科目名称
    ,qxmc varchar2(150) -- 期限名称
    ,cph varchar2(75) -- 产品编号
    ,cpejfl varchar2(75) -- 产品二级分类
    ,cpsjfl varchar2(75) -- 产品三级分类
    ,cpsijfl varchar2(75) -- 产品四级分类
    ,cpmc varchar2(150) -- 产品中文名称
    ,zxll number(15,7) -- 账户执行利率
    ,sjll number(15,7) -- 新型存款实际利率
    ,qxrq number(22,0) -- 起息日期
    ,dqrq number(22,0) -- 到期日期
    ,xhrq number(22,0) -- 销户日期
    ,zzkzqr varchar2(30) -- 最早可支取日
    ,sfzy varchar2(15) -- 是否质押
    ,sfhx varchar2(300) -- 是否核心存款
    ,bz varchar2(45) -- 币种
    ,zhye number(25,4) -- 账户余额
    ,zhyrjye number(25,4) -- 当月日均
    ,zhnrjye number(25,4) -- 年日均
    ,ftplxzcylj number(25,4) -- 当月利息支出
    ,ftplxzcnlj number(25,4) -- 累计利息支出
    ,zyjg number(25,4) -- 转移价格
    ,ftpsrylj number(25,4) -- 当月ftp转移收入
    ,ftpsrnlj number(25,4) -- 累计ftp转移收入
    ,ftpsyylj number(25,4) -- 当月ftp净收益
    ,ftpsynlj number(25,4) -- 累计ftp净收益
    ,zjywsr number(25,4) -- 中间业务收入
    ,ftplxzc number(25,4) -- ftp利息支出
    ,ftpsr number(25,4) -- ftp收入
    ,ftpsy number(25,4) -- ftp收益
    ,lxkm varchar2(75) -- 利息科目
    ,lxkmmc varchar2(150) -- 利息科目名称
    ,bzdm varchar2(15) -- 币种码值
    ,fptx varchar2(15) -- 所属条线
    ,txfpbl number(19,5) -- 条线分配比例
    ,shlllx varchar2(180) -- 赎回利率类型
    ,ydshrq number(22) -- 约定赎回日期
    ,tscpbz varchar2(90) -- 特殊产品标识
    ,xhczhll number(15,7) -- 兴惠存综合利率
    ,shll number(18,6) -- 赎回利率
    ,etl_dt date -- ETL处理日期
    ,etl_timestamp timestamp -- ETL处理时间戳
)
partition by list(etl_dt)(
    partition p_19000101 values (to_date('19000101','yyyymmdd'))
)
storage (initial 64k next 64k)
compress ${option_switch} for query high
nologging
;

-- grant
grant select on ${iol_schema}.pams_jxbb_ckftpmx_gh to ${iml_schema};
grant select on ${iol_schema}.pams_jxbb_ckftpmx_gh to ${icl_schema};
grant select on ${iol_schema}.pams_jxbb_ckftpmx_gh to ${idl_schema};
grant select on ${iol_schema}.pams_jxbb_ckftpmx_gh to ${iel_schema};

-- comment
comment on table ${iol_schema}.pams_jxbb_ckftpmx_gh is '存款明细-管户部分';
comment on column ${iol_schema}.pams_jxbb_ckftpmx_gh.tjrq is '统计日期';
comment on column ${iol_schema}.pams_jxbb_ckftpmx_gh.jxdxdh is '绩效对象代号';
comment on column ${iol_schema}.pams_jxbb_ckftpmx_gh.khdxdh is '考核对象代号';
comment on column ${iol_schema}.pams_jxbb_ckftpmx_gh.zhhm is '账户户名';
comment on column ${iol_schema}.pams_jxbb_ckftpmx_gh.zhdh is '账号代号';
comment on column ${iol_schema}.pams_jxbb_ckftpmx_gh.zzh is '子账号';
comment on column ${iol_schema}.pams_jxbb_ckftpmx_gh.zhbs is '账户标识';
comment on column ${iol_schema}.pams_jxbb_ckftpmx_gh.kh is '卡号';
comment on column ${iol_schema}.pams_jxbb_ckftpmx_gh.khh is '客户号';
comment on column ${iol_schema}.pams_jxbb_ckftpmx_gh.khjgdh is '开户机构代号';
comment on column ${iol_schema}.pams_jxbb_ckftpmx_gh.khjgmc is '开户机构名称';
comment on column ${iol_schema}.pams_jxbb_ckftpmx_gh.gsjgdh is '归属机构代号';
comment on column ${iol_schema}.pams_jxbb_ckftpmx_gh.gsjgmc is '归属机构名称';
comment on column ${iol_schema}.pams_jxbb_ckftpmx_gh.khjlgh is '客户经理工号';
comment on column ${iol_schema}.pams_jxbb_ckftpmx_gh.khjlxm is '客户经理姓名';
comment on column ${iol_schema}.pams_jxbb_ckftpmx_gh.fpbl is '分配比例';
comment on column ${iol_schema}.pams_jxbb_ckftpmx_gh.kmh is '科目号';
comment on column ${iol_schema}.pams_jxbb_ckftpmx_gh.kmmc is '科目名称';
comment on column ${iol_schema}.pams_jxbb_ckftpmx_gh.qxmc is '期限名称';
comment on column ${iol_schema}.pams_jxbb_ckftpmx_gh.cph is '产品编号';
comment on column ${iol_schema}.pams_jxbb_ckftpmx_gh.cpejfl is '产品二级分类';
comment on column ${iol_schema}.pams_jxbb_ckftpmx_gh.cpsjfl is '产品三级分类';
comment on column ${iol_schema}.pams_jxbb_ckftpmx_gh.cpsijfl is '产品四级分类';
comment on column ${iol_schema}.pams_jxbb_ckftpmx_gh.cpmc is '产品中文名称';
comment on column ${iol_schema}.pams_jxbb_ckftpmx_gh.zxll is '账户执行利率';
comment on column ${iol_schema}.pams_jxbb_ckftpmx_gh.sjll is '新型存款实际利率';
comment on column ${iol_schema}.pams_jxbb_ckftpmx_gh.qxrq is '起息日期';
comment on column ${iol_schema}.pams_jxbb_ckftpmx_gh.dqrq is '到期日期';
comment on column ${iol_schema}.pams_jxbb_ckftpmx_gh.xhrq is '销户日期';
comment on column ${iol_schema}.pams_jxbb_ckftpmx_gh.zzkzqr is '最早可支取日';
comment on column ${iol_schema}.pams_jxbb_ckftpmx_gh.sfzy is '是否质押';
comment on column ${iol_schema}.pams_jxbb_ckftpmx_gh.sfhx is '是否核心存款';
comment on column ${iol_schema}.pams_jxbb_ckftpmx_gh.bz is '币种';
comment on column ${iol_schema}.pams_jxbb_ckftpmx_gh.zhye is '账户余额';
comment on column ${iol_schema}.pams_jxbb_ckftpmx_gh.zhyrjye is '当月日均';
comment on column ${iol_schema}.pams_jxbb_ckftpmx_gh.zhnrjye is '年日均';
comment on column ${iol_schema}.pams_jxbb_ckftpmx_gh.ftplxzcylj is '当月利息支出';
comment on column ${iol_schema}.pams_jxbb_ckftpmx_gh.ftplxzcnlj is '累计利息支出';
comment on column ${iol_schema}.pams_jxbb_ckftpmx_gh.zyjg is '转移价格';
comment on column ${iol_schema}.pams_jxbb_ckftpmx_gh.ftpsrylj is '当月ftp转移收入';
comment on column ${iol_schema}.pams_jxbb_ckftpmx_gh.ftpsrnlj is '累计ftp转移收入';
comment on column ${iol_schema}.pams_jxbb_ckftpmx_gh.ftpsyylj is '当月ftp净收益';
comment on column ${iol_schema}.pams_jxbb_ckftpmx_gh.ftpsynlj is '累计ftp净收益';
comment on column ${iol_schema}.pams_jxbb_ckftpmx_gh.zjywsr is '中间业务收入';
comment on column ${iol_schema}.pams_jxbb_ckftpmx_gh.ftplxzc is 'ftp利息支出';
comment on column ${iol_schema}.pams_jxbb_ckftpmx_gh.ftpsr is 'ftp收入';
comment on column ${iol_schema}.pams_jxbb_ckftpmx_gh.ftpsy is 'ftp收益';
comment on column ${iol_schema}.pams_jxbb_ckftpmx_gh.lxkm is '利息科目';
comment on column ${iol_schema}.pams_jxbb_ckftpmx_gh.lxkmmc is '利息科目名称';
comment on column ${iol_schema}.pams_jxbb_ckftpmx_gh.bzdm is '币种码值';
comment on column ${iol_schema}.pams_jxbb_ckftpmx_gh.fptx is '所属条线';
comment on column ${iol_schema}.pams_jxbb_ckftpmx_gh.txfpbl is '条线分配比例';
comment on column ${iol_schema}.pams_jxbb_ckftpmx_gh.shlllx is '赎回利率类型';
comment on column ${iol_schema}.pams_jxbb_ckftpmx_gh.ydshrq is '约定赎回日期';
comment on column ${iol_schema}.pams_jxbb_ckftpmx_gh.tscpbz is '特殊产品标识';
comment on column ${iol_schema}.pams_jxbb_ckftpmx_gh.xhczhll is '兴惠存综合利率';
comment on column ${iol_schema}.pams_jxbb_ckftpmx_gh.shll is '赎回利率';
comment on column ${iol_schema}.pams_jxbb_ckftpmx_gh.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.pams_jxbb_ckftpmx_gh.etl_timestamp is 'ETL处理时间戳';
