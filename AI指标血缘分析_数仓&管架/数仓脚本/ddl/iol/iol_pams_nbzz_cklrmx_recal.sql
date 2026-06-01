/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol pams_nbzz_cklrmx_recal
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.pams_nbzz_cklrmx_recal
whenever sqlerror continue none;
drop table ${iol_schema}.pams_nbzz_cklrmx_recal purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.pams_nbzz_cklrmx_recal(
    tjrq number -- 统计日期
    ,khdxdh number -- 考核对象代号
    ,jxdxdh number -- 绩效对象代号
    ,jgkhdxdh number -- 机构考核对象代号
    ,kmh varchar2(60) -- 科目号
    ,fpjs varchar2(6) -- 分配角色
    ,sfhx varchar2(3) -- 是否核心
    ,bz varchar2(9) -- 币种
    ,zhdh varchar2(120) -- 账户代号
    ,zzh varchar2(120) -- 子账号
    ,zhhm varchar2(1500) -- 账户名称
    ,khh varchar2(90) -- 客户号
    ,jgdh varchar2(30) -- 机构代号
    ,qx varchar2(12) -- 期限
    ,zhbs varchar2(3) -- 账户标识
    ,ftplc number(15,7) -- FTP利差
    ,nll number(15,7) -- 年利率
    ,zyjg number(15,7) -- 转移价格
    ,zlbl number(19,5) -- 增量比例
    ,zhye number(25,4) -- 账户余额
    ,hyye number(25,4) -- 行员余额
    ,hyylj number(25,4) -- 行员月累计
    ,hyjlj number(25,4) -- 行员季累计
    ,hybnlj number(25,4) -- 行员半年累计
    ,hynlj number(25,4) -- 行员年累计
    ,ftpsr number(25,4) -- FTP收入
    ,ftpsrylj number(25,4) -- FTP收入月累计
    ,ftpsrjlj number(25,4) -- FTP收入季累计
    ,ftpsrbnlj number(25,4) -- FTP收入半年累计
    ,ftpsrnlj number(25,4) -- FTP收入年累计
    ,ftplxzc number(25,4) -- FTP利息支出
    ,ftplxzcylj number(25,4) -- FTP利息支出月累计
    ,ftplxzcjlj number(25,4) -- FTP利息支出季累计
    ,ftplxzcbnlj number(25,4) -- FTP利息支出半年累计
    ,ftplxzcnlj number(25,4) -- FTP利息支出年累计
    ,ftpsy number(25,4) -- FTP收益
    ,ftpsyylj number(25,4) -- FTP收益月累计
    ,ftpsyjlj number(25,4) -- FTP收益季累计
    ,ftpsybnlj number(25,4) -- FTP收益半年累计
    ,ftpsynlj number(25,4) -- FTP收益年累计
    ,cph varchar2(60) -- 标准产品号
    ,dnxkhbs varchar2(3) -- 当年新开户标识:0-是;1-否
    ,recal_dt number -- 重算日期
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
grant select on ${iol_schema}.pams_nbzz_cklrmx_recal to ${iml_schema};
grant select on ${iol_schema}.pams_nbzz_cklrmx_recal to ${icl_schema};
grant select on ${iol_schema}.pams_nbzz_cklrmx_recal to ${idl_schema};
grant select on ${iol_schema}.pams_nbzz_cklrmx_recal to ${iel_schema};

-- comment
comment on table ${iol_schema}.pams_nbzz_cklrmx_recal is '内部总账_存款利润明细_重算';
comment on column ${iol_schema}.pams_nbzz_cklrmx_recal.tjrq is '统计日期';
comment on column ${iol_schema}.pams_nbzz_cklrmx_recal.khdxdh is '考核对象代号';
comment on column ${iol_schema}.pams_nbzz_cklrmx_recal.jxdxdh is '绩效对象代号';
comment on column ${iol_schema}.pams_nbzz_cklrmx_recal.jgkhdxdh is '机构考核对象代号';
comment on column ${iol_schema}.pams_nbzz_cklrmx_recal.kmh is '科目号';
comment on column ${iol_schema}.pams_nbzz_cklrmx_recal.fpjs is '分配角色';
comment on column ${iol_schema}.pams_nbzz_cklrmx_recal.sfhx is '是否核心';
comment on column ${iol_schema}.pams_nbzz_cklrmx_recal.bz is '币种';
comment on column ${iol_schema}.pams_nbzz_cklrmx_recal.zhdh is '账户代号';
comment on column ${iol_schema}.pams_nbzz_cklrmx_recal.zzh is '子账号';
comment on column ${iol_schema}.pams_nbzz_cklrmx_recal.zhhm is '账户名称';
comment on column ${iol_schema}.pams_nbzz_cklrmx_recal.khh is '客户号';
comment on column ${iol_schema}.pams_nbzz_cklrmx_recal.jgdh is '机构代号';
comment on column ${iol_schema}.pams_nbzz_cklrmx_recal.qx is '期限';
comment on column ${iol_schema}.pams_nbzz_cklrmx_recal.zhbs is '账户标识';
comment on column ${iol_schema}.pams_nbzz_cklrmx_recal.ftplc is 'FTP利差';
comment on column ${iol_schema}.pams_nbzz_cklrmx_recal.nll is '年利率';
comment on column ${iol_schema}.pams_nbzz_cklrmx_recal.zyjg is '转移价格';
comment on column ${iol_schema}.pams_nbzz_cklrmx_recal.zlbl is '增量比例';
comment on column ${iol_schema}.pams_nbzz_cklrmx_recal.zhye is '账户余额';
comment on column ${iol_schema}.pams_nbzz_cklrmx_recal.hyye is '行员余额';
comment on column ${iol_schema}.pams_nbzz_cklrmx_recal.hyylj is '行员月累计';
comment on column ${iol_schema}.pams_nbzz_cklrmx_recal.hyjlj is '行员季累计';
comment on column ${iol_schema}.pams_nbzz_cklrmx_recal.hybnlj is '行员半年累计';
comment on column ${iol_schema}.pams_nbzz_cklrmx_recal.hynlj is '行员年累计';
comment on column ${iol_schema}.pams_nbzz_cklrmx_recal.ftpsr is 'FTP收入';
comment on column ${iol_schema}.pams_nbzz_cklrmx_recal.ftpsrylj is 'FTP收入月累计';
comment on column ${iol_schema}.pams_nbzz_cklrmx_recal.ftpsrjlj is 'FTP收入季累计';
comment on column ${iol_schema}.pams_nbzz_cklrmx_recal.ftpsrbnlj is 'FTP收入半年累计';
comment on column ${iol_schema}.pams_nbzz_cklrmx_recal.ftpsrnlj is 'FTP收入年累计';
comment on column ${iol_schema}.pams_nbzz_cklrmx_recal.ftplxzc is 'FTP利息支出';
comment on column ${iol_schema}.pams_nbzz_cklrmx_recal.ftplxzcylj is 'FTP利息支出月累计';
comment on column ${iol_schema}.pams_nbzz_cklrmx_recal.ftplxzcjlj is 'FTP利息支出季累计';
comment on column ${iol_schema}.pams_nbzz_cklrmx_recal.ftplxzcbnlj is 'FTP利息支出半年累计';
comment on column ${iol_schema}.pams_nbzz_cklrmx_recal.ftplxzcnlj is 'FTP利息支出年累计';
comment on column ${iol_schema}.pams_nbzz_cklrmx_recal.ftpsy is 'FTP收益';
comment on column ${iol_schema}.pams_nbzz_cklrmx_recal.ftpsyylj is 'FTP收益月累计';
comment on column ${iol_schema}.pams_nbzz_cklrmx_recal.ftpsyjlj is 'FTP收益季累计';
comment on column ${iol_schema}.pams_nbzz_cklrmx_recal.ftpsybnlj is 'FTP收益半年累计';
comment on column ${iol_schema}.pams_nbzz_cklrmx_recal.ftpsynlj is 'FTP收益年累计';
comment on column ${iol_schema}.pams_nbzz_cklrmx_recal.cph is '标准产品号';
comment on column ${iol_schema}.pams_nbzz_cklrmx_recal.dnxkhbs is '当年新开户标识:0-是;1-否';
comment on column ${iol_schema}.pams_nbzz_cklrmx_recal.recal_dt is '重算日期';
comment on column ${iol_schema}.pams_nbzz_cklrmx_recal.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.pams_nbzz_cklrmx_recal.etl_timestamp is 'ETL处理时间戳';
