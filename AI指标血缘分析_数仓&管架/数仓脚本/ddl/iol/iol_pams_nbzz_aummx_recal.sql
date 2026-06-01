/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol pams_nbzz_aummx_recal
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.pams_nbzz_aummx_recal
whenever sqlerror continue none;
drop table ${iol_schema}.pams_nbzz_aummx_recal purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.pams_nbzz_aummx_recal(
    tjrq number(22) -- 统计日期
    ,jxdxdh number(22) -- 绩效对象代号
    ,khdxdh number(22) -- 考核对象代号
    ,jgkhdxdh number(22) -- 机构考核对象代号
    ,fpjs varchar2(3) -- 分配角色
    ,aumye number(25,4) -- AUM余额
    ,zlbl number(25,4) -- 认领比例
    ,hyaumye number(25,4) -- 行员AUM余额
    ,hyaumylj number(25,4) -- 行员AUM月累计
    ,hyaumjlj number(25,4) -- 行员AUM季累计
    ,hyaumnlj number(25,4) -- 行员AUM年累计
    ,aumyrjye number(25,4) -- AUM月日均余额
    ,aumjrjye number(25,4) -- AUM季日均余额
    ,aumnrjye number(25,4) -- AUM年日均余额
    ,hyxtjhye number(25,4) -- 行员信托余额
    ,hyxtjhylj number(25,4) -- 行员信托月累计
    ,hyxtjhjlj number(25,4) -- 行员信托季累计
    ,hyxtjhnlj number(25,4) -- 行员信托年累计
    ,xtjhyrjye number(25,4) -- 系统计后月日均余额
    ,xtjhjrjye number(25,4) -- 系统计后季日均余额
    ,xtjhnrjye number(25,4) -- 系统计后年日均余额
    ,xtjhye number(25,4) -- 系统计后余额
    ,lskhbz1 varchar2(3) -- 判断是否包含一二三类账户或存单存折的非互联网客户，1-是，0-否
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
grant select on ${iol_schema}.pams_nbzz_aummx_recal to ${iml_schema};
grant select on ${iol_schema}.pams_nbzz_aummx_recal to ${icl_schema};
grant select on ${iol_schema}.pams_nbzz_aummx_recal to ${idl_schema};
grant select on ${iol_schema}.pams_nbzz_aummx_recal to ${iel_schema};

-- comment
comment on table ${iol_schema}.pams_nbzz_aummx_recal is '内部总账_AUM明细_重算';
comment on column ${iol_schema}.pams_nbzz_aummx_recal.tjrq is '统计日期';
comment on column ${iol_schema}.pams_nbzz_aummx_recal.jxdxdh is '绩效对象代号';
comment on column ${iol_schema}.pams_nbzz_aummx_recal.khdxdh is '考核对象代号';
comment on column ${iol_schema}.pams_nbzz_aummx_recal.jgkhdxdh is '机构考核对象代号';
comment on column ${iol_schema}.pams_nbzz_aummx_recal.fpjs is '分配角色';
comment on column ${iol_schema}.pams_nbzz_aummx_recal.aumye is 'AUM余额';
comment on column ${iol_schema}.pams_nbzz_aummx_recal.zlbl is '认领比例';
comment on column ${iol_schema}.pams_nbzz_aummx_recal.hyaumye is '行员AUM余额';
comment on column ${iol_schema}.pams_nbzz_aummx_recal.hyaumylj is '行员AUM月累计';
comment on column ${iol_schema}.pams_nbzz_aummx_recal.hyaumjlj is '行员AUM季累计';
comment on column ${iol_schema}.pams_nbzz_aummx_recal.hyaumnlj is '行员AUM年累计';
comment on column ${iol_schema}.pams_nbzz_aummx_recal.aumyrjye is 'AUM月日均余额';
comment on column ${iol_schema}.pams_nbzz_aummx_recal.aumjrjye is 'AUM季日均余额';
comment on column ${iol_schema}.pams_nbzz_aummx_recal.aumnrjye is 'AUM年日均余额';
comment on column ${iol_schema}.pams_nbzz_aummx_recal.hyxtjhye is '行员信托余额';
comment on column ${iol_schema}.pams_nbzz_aummx_recal.hyxtjhylj is '行员信托月累计';
comment on column ${iol_schema}.pams_nbzz_aummx_recal.hyxtjhjlj is '行员信托季累计';
comment on column ${iol_schema}.pams_nbzz_aummx_recal.hyxtjhnlj is '行员信托年累计';
comment on column ${iol_schema}.pams_nbzz_aummx_recal.xtjhyrjye is '系统计后月日均余额';
comment on column ${iol_schema}.pams_nbzz_aummx_recal.xtjhjrjye is '系统计后季日均余额';
comment on column ${iol_schema}.pams_nbzz_aummx_recal.xtjhnrjye is '系统计后年日均余额';
comment on column ${iol_schema}.pams_nbzz_aummx_recal.xtjhye is '系统计后余额';
comment on column ${iol_schema}.pams_nbzz_aummx_recal.lskhbz1 is '判断是否包含一二三类账户或存单存折的非互联网客户，1-是，0-否';
comment on column ${iol_schema}.pams_nbzz_aummx_recal.recal_dt is '重算日期';
comment on column ${iol_schema}.pams_nbzz_aummx_recal.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.pams_nbzz_aummx_recal.etl_timestamp is 'ETL处理时间戳';
