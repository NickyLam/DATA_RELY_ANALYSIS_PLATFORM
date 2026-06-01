/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol pams_nbzz_cklrmx
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.pams_nbzz_cklrmx
whenever sqlerror continue none;
drop table ${iol_schema}.pams_nbzz_cklrmx purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.pams_nbzz_cklrmx(
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
grant select on ${iol_schema}.pams_nbzz_cklrmx to ${iml_schema};
grant select on ${iol_schema}.pams_nbzz_cklrmx to ${icl_schema};
grant select on ${iol_schema}.pams_nbzz_cklrmx to ${idl_schema};
grant select on ${iol_schema}.pams_nbzz_cklrmx to ${iel_schema};

-- comment
comment on table ${iol_schema}.pams_nbzz_cklrmx is '内部总账_存款利润明细';
comment on column ${iol_schema}.pams_nbzz_cklrmx.tjrq is '统计日期';
comment on column ${iol_schema}.pams_nbzz_cklrmx.khdxdh is '考核对象代号';
comment on column ${iol_schema}.pams_nbzz_cklrmx.jxdxdh is '绩效对象代号';
comment on column ${iol_schema}.pams_nbzz_cklrmx.jgkhdxdh is '机构考核对象代号';
comment on column ${iol_schema}.pams_nbzz_cklrmx.kmh is '科目号';
comment on column ${iol_schema}.pams_nbzz_cklrmx.fpjs is '分配角色';
comment on column ${iol_schema}.pams_nbzz_cklrmx.sfhx is '是否核心';
comment on column ${iol_schema}.pams_nbzz_cklrmx.bz is '币种';
comment on column ${iol_schema}.pams_nbzz_cklrmx.zhdh is '账户代号';
comment on column ${iol_schema}.pams_nbzz_cklrmx.zzh is '子账号';
comment on column ${iol_schema}.pams_nbzz_cklrmx.zhhm is '账户名称';
comment on column ${iol_schema}.pams_nbzz_cklrmx.khh is '客户号';
comment on column ${iol_schema}.pams_nbzz_cklrmx.jgdh is '机构代号';
comment on column ${iol_schema}.pams_nbzz_cklrmx.qx is '期限';
comment on column ${iol_schema}.pams_nbzz_cklrmx.zhbs is '账户标识';
comment on column ${iol_schema}.pams_nbzz_cklrmx.ftplc is 'FTP利差';
comment on column ${iol_schema}.pams_nbzz_cklrmx.nll is '年利率';
comment on column ${iol_schema}.pams_nbzz_cklrmx.zyjg is '转移价格';
comment on column ${iol_schema}.pams_nbzz_cklrmx.zlbl is '增量比例';
comment on column ${iol_schema}.pams_nbzz_cklrmx.zhye is '账户余额';
comment on column ${iol_schema}.pams_nbzz_cklrmx.hyye is '行员余额';
comment on column ${iol_schema}.pams_nbzz_cklrmx.hyylj is '行员月累计';
comment on column ${iol_schema}.pams_nbzz_cklrmx.hyjlj is '行员季累计';
comment on column ${iol_schema}.pams_nbzz_cklrmx.hybnlj is '行员半年累计';
comment on column ${iol_schema}.pams_nbzz_cklrmx.hynlj is '行员年累计';
comment on column ${iol_schema}.pams_nbzz_cklrmx.ftpsr is 'FTP收入';
comment on column ${iol_schema}.pams_nbzz_cklrmx.ftpsrylj is 'FTP收入月累计';
comment on column ${iol_schema}.pams_nbzz_cklrmx.ftpsrjlj is 'FTP收入季累计';
comment on column ${iol_schema}.pams_nbzz_cklrmx.ftpsrbnlj is 'FTP收入半年累计';
comment on column ${iol_schema}.pams_nbzz_cklrmx.ftpsrnlj is 'FTP收入年累计';
comment on column ${iol_schema}.pams_nbzz_cklrmx.ftplxzc is 'FTP利息支出';
comment on column ${iol_schema}.pams_nbzz_cklrmx.ftplxzcylj is 'FTP利息支出月累计';
comment on column ${iol_schema}.pams_nbzz_cklrmx.ftplxzcjlj is 'FTP利息支出季累计';
comment on column ${iol_schema}.pams_nbzz_cklrmx.ftplxzcbnlj is 'FTP利息支出半年累计';
comment on column ${iol_schema}.pams_nbzz_cklrmx.ftplxzcnlj is 'FTP利息支出年累计';
comment on column ${iol_schema}.pams_nbzz_cklrmx.ftpsy is 'FTP收益';
comment on column ${iol_schema}.pams_nbzz_cklrmx.ftpsyylj is 'FTP收益月累计';
comment on column ${iol_schema}.pams_nbzz_cklrmx.ftpsyjlj is 'FTP收益季累计';
comment on column ${iol_schema}.pams_nbzz_cklrmx.ftpsybnlj is 'FTP收益半年累计';
comment on column ${iol_schema}.pams_nbzz_cklrmx.ftpsynlj is 'FTP收益年累计';
comment on column ${iol_schema}.pams_nbzz_cklrmx.cph is '标准产品号';
comment on column ${iol_schema}.pams_nbzz_cklrmx.dnxkhbs is '当年新开户标识:0-是;1-否';
comment on column ${iol_schema}.pams_nbzz_cklrmx.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.pams_nbzz_cklrmx.etl_timestamp is 'ETL处理时间戳';
