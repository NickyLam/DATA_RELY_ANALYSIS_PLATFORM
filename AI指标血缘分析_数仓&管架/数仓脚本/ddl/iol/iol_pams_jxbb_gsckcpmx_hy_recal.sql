/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol pams_jxbb_gsckcpmx_hy_recal
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.pams_jxbb_gsckcpmx_hy_recal
whenever sqlerror continue none;
drop table ${iol_schema}.pams_jxbb_gsckcpmx_hy_recal purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.pams_jxbb_gsckcpmx_hy_recal(
    tjrq number(22) -- 数据日期
    ,khdxdh number(22) -- 行员考核对象代号
    ,fpjs varchar2(6) -- 分配角色
    ,cpbh varchar2(60) -- 产品编号
    ,cpmc varchar2(1500) -- 产品名称
    ,kmh varchar2(60) -- 科目号
    ,bz varchar2(9) -- 币种
    ,zzh varchar2(120) -- 子账户
    ,zhdh varchar2(120) -- 账户
    ,zhbs varchar2(3) -- 账户标识
    ,khh varchar2(90) -- 客户号
    ,bzbs varchar2(3) -- 币种标识：区分是否是外币折美元
    ,zhye number(25,4) -- 余额
    ,zhyrjye number(25,4) -- 月日均
    ,zhjrjye number(25,4) -- 季日均
    ,zhnrjye number(25,4) -- 年日均
    ,ftpsy number(25,4) -- ftp净收入(时点)
    ,ftpsyylj number(25,4) -- ftp净收入(月累计)
    ,ftpsyjlj number(25,4) -- ftp净收入(季累计)
    ,ftpsynlj number(25,4) -- ftp净收入(年累计)
    ,ftplxzc number(25,4) -- FTP利息支出
    ,ftplxzcylj number(25,4) -- FTP利息支出月累计
    ,ftplxzcjlj number(25,4) -- FTP利息支出季累计
    ,ftplxzcnlj number(25,4) -- FTP利息支出年累计
    ,ftpsr number(25,4) -- 累计利息收入时点
    ,ftpsrylj number(25,4) -- 累计利息收入月累计
    ,ftpsrjlj number(25,4) -- 累计利息收入季累计
    ,ftpsrnlj number(25,4) -- 累计利息收入年累计
    ,recal_dt number(22) -- 重算日期
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
grant select on ${iol_schema}.pams_jxbb_gsckcpmx_hy_recal to ${iml_schema};
grant select on ${iol_schema}.pams_jxbb_gsckcpmx_hy_recal to ${icl_schema};
grant select on ${iol_schema}.pams_jxbb_gsckcpmx_hy_recal to ${idl_schema};
grant select on ${iol_schema}.pams_jxbb_gsckcpmx_hy_recal to ${iel_schema};

-- comment
comment on table ${iol_schema}.pams_jxbb_gsckcpmx_hy_recal is '绩效报表-公司存款产品明细-行员_重算';
comment on column ${iol_schema}.pams_jxbb_gsckcpmx_hy_recal.tjrq is '数据日期';
comment on column ${iol_schema}.pams_jxbb_gsckcpmx_hy_recal.khdxdh is '行员考核对象代号';
comment on column ${iol_schema}.pams_jxbb_gsckcpmx_hy_recal.fpjs is '分配角色';
comment on column ${iol_schema}.pams_jxbb_gsckcpmx_hy_recal.cpbh is '产品编号';
comment on column ${iol_schema}.pams_jxbb_gsckcpmx_hy_recal.cpmc is '产品名称';
comment on column ${iol_schema}.pams_jxbb_gsckcpmx_hy_recal.kmh is '科目号';
comment on column ${iol_schema}.pams_jxbb_gsckcpmx_hy_recal.bz is '币种';
comment on column ${iol_schema}.pams_jxbb_gsckcpmx_hy_recal.zzh is '子账户';
comment on column ${iol_schema}.pams_jxbb_gsckcpmx_hy_recal.zhdh is '账户';
comment on column ${iol_schema}.pams_jxbb_gsckcpmx_hy_recal.zhbs is '账户标识';
comment on column ${iol_schema}.pams_jxbb_gsckcpmx_hy_recal.khh is '客户号';
comment on column ${iol_schema}.pams_jxbb_gsckcpmx_hy_recal.bzbs is '币种标识：区分是否是外币折美元';
comment on column ${iol_schema}.pams_jxbb_gsckcpmx_hy_recal.zhye is '余额';
comment on column ${iol_schema}.pams_jxbb_gsckcpmx_hy_recal.zhyrjye is '月日均';
comment on column ${iol_schema}.pams_jxbb_gsckcpmx_hy_recal.zhjrjye is '季日均';
comment on column ${iol_schema}.pams_jxbb_gsckcpmx_hy_recal.zhnrjye is '年日均';
comment on column ${iol_schema}.pams_jxbb_gsckcpmx_hy_recal.ftpsy is 'ftp净收入(时点)';
comment on column ${iol_schema}.pams_jxbb_gsckcpmx_hy_recal.ftpsyylj is 'ftp净收入(月累计)';
comment on column ${iol_schema}.pams_jxbb_gsckcpmx_hy_recal.ftpsyjlj is 'ftp净收入(季累计)';
comment on column ${iol_schema}.pams_jxbb_gsckcpmx_hy_recal.ftpsynlj is 'ftp净收入(年累计)';
comment on column ${iol_schema}.pams_jxbb_gsckcpmx_hy_recal.ftplxzc is 'FTP利息支出';
comment on column ${iol_schema}.pams_jxbb_gsckcpmx_hy_recal.ftplxzcylj is 'FTP利息支出月累计';
comment on column ${iol_schema}.pams_jxbb_gsckcpmx_hy_recal.ftplxzcjlj is 'FTP利息支出季累计';
comment on column ${iol_schema}.pams_jxbb_gsckcpmx_hy_recal.ftplxzcnlj is 'FTP利息支出年累计';
comment on column ${iol_schema}.pams_jxbb_gsckcpmx_hy_recal.ftpsr is '累计利息收入时点';
comment on column ${iol_schema}.pams_jxbb_gsckcpmx_hy_recal.ftpsrylj is '累计利息收入月累计';
comment on column ${iol_schema}.pams_jxbb_gsckcpmx_hy_recal.ftpsrjlj is '累计利息收入季累计';
comment on column ${iol_schema}.pams_jxbb_gsckcpmx_hy_recal.ftpsrnlj is '累计利息收入年累计';
comment on column ${iol_schema}.pams_jxbb_gsckcpmx_hy_recal.recal_dt is '重算日期';
comment on column ${iol_schema}.pams_jxbb_gsckcpmx_hy_recal.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.pams_jxbb_gsckcpmx_hy_recal.etl_timestamp is 'ETL处理时间戳';
