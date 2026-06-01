/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol pams_nbzz_dfgzkhmx
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.pams_nbzz_dfgzkhmx
whenever sqlerror continue none;
drop table ${iol_schema}.pams_nbzz_dfgzkhmx purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.pams_nbzz_dfgzkhmx(
    tjrq number(22) -- 统计日期
    ,sjbh varchar2(750) -- 事件编号
    ,zckhh varchar2(90) -- 转出客户号
    ,khdbbz varchar2(3) -- 考核达标标志：0-达标；1-未达标
    ,zczhdh varchar2(180) -- 转出账户代号
    ,zczhmc varchar2(1500) -- 转出账户名称
    ,dfly varchar2(6) -- 代发来源：01-柜面；02-企业网银；03-小额交易
    ,zrkhh varchar2(180) -- 转入客户号
    ,zrjyje number(30,4) -- 转入交易金额
    ,fpje number(30,4) -- 分配金额
    ,jyrq number(22) -- 交易日期
    ,fpjs varchar2(6) -- 分配角色
    ,zlbl number(19,5) -- 增量比例
    ,khdxdh number(22) -- 行员考核对象代号
    ,jgkhdxdh number(22) -- 机构考核对象代号
    ,jddbbz varchar2(3) -- 进度达标标志(0-达标 1-未达标)
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
grant select on ${iol_schema}.pams_nbzz_dfgzkhmx to ${iml_schema};
grant select on ${iol_schema}.pams_nbzz_dfgzkhmx to ${icl_schema};
grant select on ${iol_schema}.pams_nbzz_dfgzkhmx to ${idl_schema};
grant select on ${iol_schema}.pams_nbzz_dfgzkhmx to ${iel_schema};

-- comment
comment on table ${iol_schema}.pams_nbzz_dfgzkhmx is '内部总账-代发工资考核明细账';
comment on column ${iol_schema}.pams_nbzz_dfgzkhmx.tjrq is '统计日期';
comment on column ${iol_schema}.pams_nbzz_dfgzkhmx.sjbh is '事件编号';
comment on column ${iol_schema}.pams_nbzz_dfgzkhmx.zckhh is '转出客户号';
comment on column ${iol_schema}.pams_nbzz_dfgzkhmx.khdbbz is '考核达标标志：0-达标；1-未达标';
comment on column ${iol_schema}.pams_nbzz_dfgzkhmx.zczhdh is '转出账户代号';
comment on column ${iol_schema}.pams_nbzz_dfgzkhmx.zczhmc is '转出账户名称';
comment on column ${iol_schema}.pams_nbzz_dfgzkhmx.dfly is '代发来源：01-柜面；02-企业网银；03-小额交易';
comment on column ${iol_schema}.pams_nbzz_dfgzkhmx.zrkhh is '转入客户号';
comment on column ${iol_schema}.pams_nbzz_dfgzkhmx.zrjyje is '转入交易金额';
comment on column ${iol_schema}.pams_nbzz_dfgzkhmx.fpje is '分配金额';
comment on column ${iol_schema}.pams_nbzz_dfgzkhmx.jyrq is '交易日期';
comment on column ${iol_schema}.pams_nbzz_dfgzkhmx.fpjs is '分配角色';
comment on column ${iol_schema}.pams_nbzz_dfgzkhmx.zlbl is '增量比例';
comment on column ${iol_schema}.pams_nbzz_dfgzkhmx.khdxdh is '行员考核对象代号';
comment on column ${iol_schema}.pams_nbzz_dfgzkhmx.jgkhdxdh is '机构考核对象代号';
comment on column ${iol_schema}.pams_nbzz_dfgzkhmx.jddbbz is '进度达标标志(0-达标 1-未达标)';
comment on column ${iol_schema}.pams_nbzz_dfgzkhmx.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.pams_nbzz_dfgzkhmx.etl_timestamp is 'ETL处理时间戳';
