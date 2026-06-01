/*
Purpose:    技术缓冲层-建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py itl itl_edw_pams_jxbb_ckftpmx
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${itl_schema}.itl_edw_pams_jxbb_ckftpmx
whenever sqlerror continue none;
drop table ${itl_schema}.itl_edw_pams_jxbb_ckftpmx purge;

whenever sqlerror exit sql.sqlcode;
create table ${itl_schema}.itl_edw_pams_jxbb_ckftpmx(
    tjrq number(22) -- 
    ,jxdxdh number(22) -- 
    ,khdxdh number(22) -- 
    ,zhhm varchar2(750) -- 账户户名
    ,zhdh varchar2(75) -- 
    ,zzh varchar2(75) -- 
    ,zhbs varchar2(3) -- 
    ,kh varchar2(150) -- 
    ,khh varchar2(150) -- 
    ,khjgdh varchar2(75) -- 
    ,khjgmc varchar2(150) -- 
    ,gsjgdh varchar2(75) -- 
    ,gsjgmc varchar2(150) -- 
    ,khjlgh varchar2(150) -- 
    ,khjlxm varchar2(150) -- 
    ,fpbl number(19,5) -- 
    ,kmh varchar2(75) -- 
    ,kmmc varchar2(150) -- 
    ,qxmc varchar2(150) -- 
    ,cph varchar2(75) -- 
    ,cpejfl varchar2(75) -- 
    ,cpsjfl varchar2(75) -- 
    ,cpsijfl varchar2(75) -- 
    ,cpmc varchar2(150) -- 
    ,zxll number(15,7) -- 
    ,sjll number(15,7) -- 
    ,qxrq number(22) -- 
    ,dqrq number(22) -- 
    ,xhrq number(22) -- 
    ,zzkzqr varchar2(30) -- 
    ,sfzy varchar2(15) -- 
    ,sfhx varchar2(300) -- 
    ,bz varchar2(45) -- 
    ,zhye number(25,4) -- 
    ,zhyrjye number(25,4) -- 
    ,zhnrjye number(25,4) -- 
    ,ftplxzcylj number(25,4) -- 
    ,ftplxzcnlj number(25,4) -- 
    ,zyjg number(25,4) -- 
    ,ftpsrylj number(25,4) -- 
    ,ftpsrnlj number(25,4) -- 
    ,ftpsyylj number(25,4) -- 
    ,ftpsynlj number(25,4) -- 
    ,zjywsr number(25,4) -- 
    ,ftplxzc number(25,4) -- 
    ,ftpsr number(25,4) -- 
    ,ftpsy number(25,4) -- 
    ,lxkm varchar2(75) -- 
    ,lxkmmc varchar2(150) -- 
    ,bzdm varchar2(15) -- 币种码值
    ,qx varchar2(15) -- 账户期限
    ,ydshrq number(22) -- 大额存单约定赎回日期
    ,zhjrjye number(25,4) -- 季日均余额
    ,xhczhll number(15,7) -- 兴惠存综合利率(%)
    ,etl_dt date -- ETL处理日期
    ,etl_timestamp timestamp -- ETL处理时间戳
)
partition by list(etl_dt)(
    partition p_19000101 values (to_date('19000101','yyyymmdd'))
)
storage (initial 1024k next 1024k)
compress ${option_switch} for query high
nologging
;

-- grant
grant select on ${itl_schema}.itl_edw_pams_jxbb_ckftpmx to ${iol_schema};

-- comment
comment on table ${itl_schema}.itl_edw_pams_jxbb_ckftpmx is '客户存款ftp结果表';
comment on column ${itl_schema}.itl_edw_pams_jxbb_ckftpmx.tjrq is '';
comment on column ${itl_schema}.itl_edw_pams_jxbb_ckftpmx.jxdxdh is '';
comment on column ${itl_schema}.itl_edw_pams_jxbb_ckftpmx.khdxdh is '';
comment on column ${itl_schema}.itl_edw_pams_jxbb_ckftpmx.zhhm is '账户户名';
comment on column ${itl_schema}.itl_edw_pams_jxbb_ckftpmx.zhdh is '';
comment on column ${itl_schema}.itl_edw_pams_jxbb_ckftpmx.zzh is '';
comment on column ${itl_schema}.itl_edw_pams_jxbb_ckftpmx.zhbs is '';
comment on column ${itl_schema}.itl_edw_pams_jxbb_ckftpmx.kh is '';
comment on column ${itl_schema}.itl_edw_pams_jxbb_ckftpmx.khh is '';
comment on column ${itl_schema}.itl_edw_pams_jxbb_ckftpmx.khjgdh is '';
comment on column ${itl_schema}.itl_edw_pams_jxbb_ckftpmx.khjgmc is '';
comment on column ${itl_schema}.itl_edw_pams_jxbb_ckftpmx.gsjgdh is '';
comment on column ${itl_schema}.itl_edw_pams_jxbb_ckftpmx.gsjgmc is '';
comment on column ${itl_schema}.itl_edw_pams_jxbb_ckftpmx.khjlgh is '';
comment on column ${itl_schema}.itl_edw_pams_jxbb_ckftpmx.khjlxm is '';
comment on column ${itl_schema}.itl_edw_pams_jxbb_ckftpmx.fpbl is '';
comment on column ${itl_schema}.itl_edw_pams_jxbb_ckftpmx.kmh is '';
comment on column ${itl_schema}.itl_edw_pams_jxbb_ckftpmx.kmmc is '';
comment on column ${itl_schema}.itl_edw_pams_jxbb_ckftpmx.qxmc is '';
comment on column ${itl_schema}.itl_edw_pams_jxbb_ckftpmx.cph is '';
comment on column ${itl_schema}.itl_edw_pams_jxbb_ckftpmx.cpejfl is '';
comment on column ${itl_schema}.itl_edw_pams_jxbb_ckftpmx.cpsjfl is '';
comment on column ${itl_schema}.itl_edw_pams_jxbb_ckftpmx.cpsijfl is '';
comment on column ${itl_schema}.itl_edw_pams_jxbb_ckftpmx.cpmc is '';
comment on column ${itl_schema}.itl_edw_pams_jxbb_ckftpmx.zxll is '';
comment on column ${itl_schema}.itl_edw_pams_jxbb_ckftpmx.sjll is '';
comment on column ${itl_schema}.itl_edw_pams_jxbb_ckftpmx.qxrq is '';
comment on column ${itl_schema}.itl_edw_pams_jxbb_ckftpmx.dqrq is '';
comment on column ${itl_schema}.itl_edw_pams_jxbb_ckftpmx.xhrq is '';
comment on column ${itl_schema}.itl_edw_pams_jxbb_ckftpmx.zzkzqr is '';
comment on column ${itl_schema}.itl_edw_pams_jxbb_ckftpmx.sfzy is '';
comment on column ${itl_schema}.itl_edw_pams_jxbb_ckftpmx.sfhx is '';
comment on column ${itl_schema}.itl_edw_pams_jxbb_ckftpmx.bz is '';
comment on column ${itl_schema}.itl_edw_pams_jxbb_ckftpmx.zhye is '';
comment on column ${itl_schema}.itl_edw_pams_jxbb_ckftpmx.zhyrjye is '';
comment on column ${itl_schema}.itl_edw_pams_jxbb_ckftpmx.zhnrjye is '';
comment on column ${itl_schema}.itl_edw_pams_jxbb_ckftpmx.ftplxzcylj is '';
comment on column ${itl_schema}.itl_edw_pams_jxbb_ckftpmx.ftplxzcnlj is '';
comment on column ${itl_schema}.itl_edw_pams_jxbb_ckftpmx.zyjg is '';
comment on column ${itl_schema}.itl_edw_pams_jxbb_ckftpmx.ftpsrylj is '';
comment on column ${itl_schema}.itl_edw_pams_jxbb_ckftpmx.ftpsrnlj is '';
comment on column ${itl_schema}.itl_edw_pams_jxbb_ckftpmx.ftpsyylj is '';
comment on column ${itl_schema}.itl_edw_pams_jxbb_ckftpmx.ftpsynlj is '';
comment on column ${itl_schema}.itl_edw_pams_jxbb_ckftpmx.zjywsr is '';
comment on column ${itl_schema}.itl_edw_pams_jxbb_ckftpmx.ftplxzc is '';
comment on column ${itl_schema}.itl_edw_pams_jxbb_ckftpmx.ftpsr is '';
comment on column ${itl_schema}.itl_edw_pams_jxbb_ckftpmx.ftpsy is '';
comment on column ${itl_schema}.itl_edw_pams_jxbb_ckftpmx.lxkm is '';
comment on column ${itl_schema}.itl_edw_pams_jxbb_ckftpmx.lxkmmc is '';
comment on column ${itl_schema}.itl_edw_pams_jxbb_ckftpmx.bzdm is '币种码值';
comment on column ${itl_schema}.itl_edw_pams_jxbb_ckftpmx.qx is '账户期限';
comment on column ${itl_schema}.itl_edw_pams_jxbb_ckftpmx.ydshrq is '大额存单约定赎回日期';
comment on column ${itl_schema}.itl_edw_pams_jxbb_ckftpmx.zhjrjye is '季日均余额';
comment on column ${itl_schema}.itl_edw_pams_jxbb_ckftpmx.xhczhll is '兴惠存综合利率(%)';
comment on column ${itl_schema}.itl_edw_pams_jxbb_ckftpmx.etl_dt is 'ETL处理日期';
comment on column ${itl_schema}.itl_edw_pams_jxbb_ckftpmx.etl_timestamp is 'ETL处理时间戳';
