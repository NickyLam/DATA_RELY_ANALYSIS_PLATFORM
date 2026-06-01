/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol pams_nbzz_aummx
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.pams_nbzz_aummx
whenever sqlerror continue none;
drop table ${iol_schema}.pams_nbzz_aummx purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.pams_nbzz_aummx(
    tjrq number(22) -- 统计日期
    ,jxdxdh number(22) -- 绩效对象代号
    ,khdxdh number(22) -- 考核对象代号
    ,jgkhdxdh number(22) -- 机构考核对象代号
    ,fpjs varchar2(2) -- 分配角色
    ,aumye number(25,4) -- AUM余额
    ,zlbl number(25,4) -- 增量比例
    ,hyaumye number(25,4) -- 行员AUM余额
    ,hyaumylj number(25,4) -- 行员AUM月累计
    ,hyaumjlj number(25,4) -- 行员AUM季累计
    ,hyaumnlj number(25,4) -- 行员AUM年累计
    ,aumyrjye number(25,4) -- AUM月日均余额
    ,aumjrjye number(25,4) -- AUM季日均余额
    ,aumnrjye number(25,4) -- AUM年日均余额
    ,hyxtjhye number(25,4) -- 行员信托余额
    ,hyxtjhylj number(25,4) -- 行员信托计划月累计
    ,hyxtjhjlj number(25,4) -- 行员信托季累计
    ,hyxtjhnlj number(25,4) -- 行员信托年累计
    ,xtjhyrjye number(25,4) -- 信托计划月日均余额
    ,xtjhjrjye number(25,4) -- 信托计划季日均余额
    ,xtjhnrjye number(25,4) -- 信托计划年日均余额
    ,xtjhye number(25,4) -- 信托计划余额
    ,lskhbz1 varchar2(2) -- 判断是否包含一二三类账户或存单存折的非互联网客户，1-是，0-否
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
grant select on ${iol_schema}.pams_nbzz_aummx to ${iml_schema};
grant select on ${iol_schema}.pams_nbzz_aummx to ${icl_schema};
grant select on ${iol_schema}.pams_nbzz_aummx to ${idl_schema};
grant select on ${iol_schema}.pams_nbzz_aummx to ${iel_schema};

-- comment
comment on table ${iol_schema}.pams_nbzz_aummx is '内部总账_AUM明细';
comment on column ${iol_schema}.pams_nbzz_aummx.tjrq is '统计日期';
comment on column ${iol_schema}.pams_nbzz_aummx.jxdxdh is '绩效对象代号';
comment on column ${iol_schema}.pams_nbzz_aummx.khdxdh is '考核对象代号';
comment on column ${iol_schema}.pams_nbzz_aummx.jgkhdxdh is '机构考核对象代号';
comment on column ${iol_schema}.pams_nbzz_aummx.fpjs is '分配角色';
comment on column ${iol_schema}.pams_nbzz_aummx.aumye is 'AUM余额';
comment on column ${iol_schema}.pams_nbzz_aummx.zlbl is '增量比例';
comment on column ${iol_schema}.pams_nbzz_aummx.hyaumye is '行员AUM余额';
comment on column ${iol_schema}.pams_nbzz_aummx.hyaumylj is '行员AUM月累计';
comment on column ${iol_schema}.pams_nbzz_aummx.hyaumjlj is '行员AUM季累计';
comment on column ${iol_schema}.pams_nbzz_aummx.hyaumnlj is '行员AUM年累计';
comment on column ${iol_schema}.pams_nbzz_aummx.aumyrjye is 'AUM月日均余额';
comment on column ${iol_schema}.pams_nbzz_aummx.aumjrjye is 'AUM季日均余额';
comment on column ${iol_schema}.pams_nbzz_aummx.aumnrjye is 'AUM年日均余额';
comment on column ${iol_schema}.pams_nbzz_aummx.hyxtjhye is '行员信托余额';
comment on column ${iol_schema}.pams_nbzz_aummx.hyxtjhylj is '行员信托计划月累计';
comment on column ${iol_schema}.pams_nbzz_aummx.hyxtjhjlj is '行员信托季累计';
comment on column ${iol_schema}.pams_nbzz_aummx.hyxtjhnlj is '行员信托年累计';
comment on column ${iol_schema}.pams_nbzz_aummx.xtjhyrjye is '信托计划月日均余额';
comment on column ${iol_schema}.pams_nbzz_aummx.xtjhjrjye is '信托计划季日均余额';
comment on column ${iol_schema}.pams_nbzz_aummx.xtjhnrjye is '信托计划年日均余额';
comment on column ${iol_schema}.pams_nbzz_aummx.xtjhye is '信托计划余额';
comment on column ${iol_schema}.pams_nbzz_aummx.lskhbz1 is '判断是否包含一二三类账户或存单存折的非互联网客户，1-是，0-否';
comment on column ${iol_schema}.pams_nbzz_aummx.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.pams_nbzz_aummx.etl_timestamp is 'ETL处理时间戳';
