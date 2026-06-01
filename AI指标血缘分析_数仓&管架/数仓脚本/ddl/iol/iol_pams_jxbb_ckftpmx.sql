/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol pams_jxbb_ckftpmx
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.pams_jxbb_ckftpmx
whenever sqlerror continue none;
drop table ${iol_schema}.pams_jxbb_ckftpmx purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.pams_jxbb_ckftpmx(
    tjrq number(22,0) -- 统计日期
    ,jxdxdh number(22,0) -- 绩效对象代号
    ,khdxdh number(22,0) -- 考核对象代号
    ,zhhm varchar2(750) -- 账户名称
    ,zhdh varchar2(75) -- 账户代号
    ,zzh varchar2(75) -- 子账号
    ,zhbs varchar2(3) -- 账户标识
    ,kh varchar2(150) -- 卡号
    ,khh varchar2(150) -- 客户号
    ,khjgdh varchar2(75) -- 开户机构代号
    ,khjgmc varchar2(150) -- 开户机构名称
    ,gsjgdh varchar2(75) -- 归属机构代号
    ,gsjgmc varchar2(150) -- 归属机构名称
    ,khjlgh varchar2(150) -- 客户经理工号
    ,khjlxm varchar2(150) -- 客户经理名称
    ,fpbl number(19,5) -- 分配比例
    ,kmh varchar2(75) -- 科目号
    ,kmmc varchar2(150) -- 科目名称
    ,qxmc varchar2(150) -- 期限名称
    ,cph varchar2(75) -- 产品号
    ,cpejfl varchar2(75) -- 产品二级分类
    ,cpsjfl varchar2(75) -- 产品四级分类
    ,cpsijfl varchar2(75) -- 产品四级分类
    ,cpmc varchar2(150) -- 产品名称
    ,zxll number(15,7) -- 执行利率
    ,sjll number(15,7) -- 新型存款实际利率
    ,qxrq number(22,0) -- 起息日期
    ,dqrq number(22,0) -- 到期日期
    ,xhrq number(22,0) -- 销户日期
    ,zzkzqr varchar2(30) -- 最早可支取日
    ,sfzy varchar2(15) -- 是否质押
    ,sfhx varchar2(300) -- 是否核心
    ,bz varchar2(45) -- 币种
    ,zhye number(25,4) -- 账户余额
    ,zhyrjye number(25,4) -- 账户月日均余额
    ,zhnrjye number(25,4) -- 账户年日均余额
    ,ftplxzcylj number(25,4) -- FTP利息支出月累计
    ,ftplxzcnlj number(25,4) -- FTP利息支出年累计
    ,zyjg number(25,4) -- 转移价格
    ,ftpsrylj number(25,4) -- FTP收入月累计
    ,ftpsrnlj number(25,4) -- FTP收入年累计
    ,ftpsyylj number(25,4) -- FTP收益月累计
    ,ftpsynlj number(25,4) -- FTP收益年累计
    ,zjywsr number(25,4) -- 中间业务收入
    ,ftplxzc number(25,4) -- FTP利息支出
    ,ftpsr number(25,4) -- FTP收入
    ,ftpsy number(25,4) -- FTP收益
    ,lxkm varchar2(75) -- 利息科目
    ,lxkmmc varchar2(150) -- 利息科目名称
    ,bzdm varchar2(15) -- 币种码值
    ,txfpbl number(19,5) -- 条线分配比例
    ,fptx varchar2(15) -- 分配条线
    ,qx varchar2(15) -- 账户期限
    ,ydshrq number(22) -- 大额存单约定赎回日期
    ,sjssjgdh varchar2(15) -- 实际所属机构号
    ,zhjrjye number(25,4) -- 季日均余额
    ,xhczhll number(15,7) -- 兴惠存综合利率(%)
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
grant select on ${iol_schema}.pams_jxbb_ckftpmx to ${iml_schema};
grant select on ${iol_schema}.pams_jxbb_ckftpmx to ${icl_schema};
grant select on ${iol_schema}.pams_jxbb_ckftpmx to ${idl_schema};
grant select on ${iol_schema}.pams_jxbb_ckftpmx to ${iel_schema};

-- comment
comment on table ${iol_schema}.pams_jxbb_ckftpmx is '客户存款ftp结果表';
comment on column ${iol_schema}.pams_jxbb_ckftpmx.tjrq is '统计日期';
comment on column ${iol_schema}.pams_jxbb_ckftpmx.jxdxdh is '绩效对象代号';
comment on column ${iol_schema}.pams_jxbb_ckftpmx.khdxdh is '考核对象代号';
comment on column ${iol_schema}.pams_jxbb_ckftpmx.zhhm is '账户名称';
comment on column ${iol_schema}.pams_jxbb_ckftpmx.zhdh is '账户代号';
comment on column ${iol_schema}.pams_jxbb_ckftpmx.zzh is '子账号';
comment on column ${iol_schema}.pams_jxbb_ckftpmx.zhbs is '账户标识';
comment on column ${iol_schema}.pams_jxbb_ckftpmx.kh is '卡号';
comment on column ${iol_schema}.pams_jxbb_ckftpmx.khh is '客户号';
comment on column ${iol_schema}.pams_jxbb_ckftpmx.khjgdh is '开户机构代号';
comment on column ${iol_schema}.pams_jxbb_ckftpmx.khjgmc is '开户机构名称';
comment on column ${iol_schema}.pams_jxbb_ckftpmx.gsjgdh is '归属机构代号';
comment on column ${iol_schema}.pams_jxbb_ckftpmx.gsjgmc is '归属机构名称';
comment on column ${iol_schema}.pams_jxbb_ckftpmx.khjlgh is '客户经理工号';
comment on column ${iol_schema}.pams_jxbb_ckftpmx.khjlxm is '客户经理名称';
comment on column ${iol_schema}.pams_jxbb_ckftpmx.fpbl is '分配比例';
comment on column ${iol_schema}.pams_jxbb_ckftpmx.kmh is '科目号';
comment on column ${iol_schema}.pams_jxbb_ckftpmx.kmmc is '科目名称';
comment on column ${iol_schema}.pams_jxbb_ckftpmx.qxmc is '期限名称';
comment on column ${iol_schema}.pams_jxbb_ckftpmx.cph is '产品号';
comment on column ${iol_schema}.pams_jxbb_ckftpmx.cpejfl is '产品二级分类';
comment on column ${iol_schema}.pams_jxbb_ckftpmx.cpsjfl is '产品四级分类';
comment on column ${iol_schema}.pams_jxbb_ckftpmx.cpsijfl is '产品四级分类';
comment on column ${iol_schema}.pams_jxbb_ckftpmx.cpmc is '产品名称';
comment on column ${iol_schema}.pams_jxbb_ckftpmx.zxll is '执行利率';
comment on column ${iol_schema}.pams_jxbb_ckftpmx.sjll is '新型存款实际利率';
comment on column ${iol_schema}.pams_jxbb_ckftpmx.qxrq is '起息日期';
comment on column ${iol_schema}.pams_jxbb_ckftpmx.dqrq is '到期日期';
comment on column ${iol_schema}.pams_jxbb_ckftpmx.xhrq is '销户日期';
comment on column ${iol_schema}.pams_jxbb_ckftpmx.zzkzqr is '最早可支取日';
comment on column ${iol_schema}.pams_jxbb_ckftpmx.sfzy is '是否质押';
comment on column ${iol_schema}.pams_jxbb_ckftpmx.sfhx is '是否核心';
comment on column ${iol_schema}.pams_jxbb_ckftpmx.bz is '币种';
comment on column ${iol_schema}.pams_jxbb_ckftpmx.zhye is '账户余额';
comment on column ${iol_schema}.pams_jxbb_ckftpmx.zhyrjye is '账户月日均余额';
comment on column ${iol_schema}.pams_jxbb_ckftpmx.zhnrjye is '账户年日均余额';
comment on column ${iol_schema}.pams_jxbb_ckftpmx.ftplxzcylj is 'FTP利息支出月累计';
comment on column ${iol_schema}.pams_jxbb_ckftpmx.ftplxzcnlj is 'FTP利息支出年累计';
comment on column ${iol_schema}.pams_jxbb_ckftpmx.zyjg is '转移价格';
comment on column ${iol_schema}.pams_jxbb_ckftpmx.ftpsrylj is 'FTP收入月累计';
comment on column ${iol_schema}.pams_jxbb_ckftpmx.ftpsrnlj is 'FTP收入年累计';
comment on column ${iol_schema}.pams_jxbb_ckftpmx.ftpsyylj is 'FTP收益月累计';
comment on column ${iol_schema}.pams_jxbb_ckftpmx.ftpsynlj is 'FTP收益年累计';
comment on column ${iol_schema}.pams_jxbb_ckftpmx.zjywsr is '中间业务收入';
comment on column ${iol_schema}.pams_jxbb_ckftpmx.ftplxzc is 'FTP利息支出';
comment on column ${iol_schema}.pams_jxbb_ckftpmx.ftpsr is 'FTP收入';
comment on column ${iol_schema}.pams_jxbb_ckftpmx.ftpsy is 'FTP收益';
comment on column ${iol_schema}.pams_jxbb_ckftpmx.lxkm is '利息科目';
comment on column ${iol_schema}.pams_jxbb_ckftpmx.lxkmmc is '利息科目名称';
comment on column ${iol_schema}.pams_jxbb_ckftpmx.bzdm is '币种码值';
comment on column ${iol_schema}.pams_jxbb_ckftpmx.txfpbl is '条线分配比例';
comment on column ${iol_schema}.pams_jxbb_ckftpmx.fptx is '分配条线';
comment on column ${iol_schema}.pams_jxbb_ckftpmx.qx is '账户期限';
comment on column ${iol_schema}.pams_jxbb_ckftpmx.ydshrq is '大额存单约定赎回日期';
comment on column ${iol_schema}.pams_jxbb_ckftpmx.sjssjgdh is '实际所属机构号';
comment on column ${iol_schema}.pams_jxbb_ckftpmx.zhjrjye is '季日均余额';
comment on column ${iol_schema}.pams_jxbb_ckftpmx.xhczhll is '兴惠存综合利率(%)';
comment on column ${iol_schema}.pams_jxbb_ckftpmx.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.pams_jxbb_ckftpmx.etl_timestamp is 'ETL处理时间戳';
