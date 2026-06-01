/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol nrrs_ci_repdatalist
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.nrrs_ci_repdatalist
whenever sqlerror continue none;
drop table ${iol_schema}.nrrs_ci_repdatalist purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.nrrs_ci_repdatalist(
    custid varchar2(30) -- 客户号
    ,repno varchar2(8) -- 报表期数
    ,caliber varchar2(6) -- 报表口径
    ,frepcode varchar2(4) -- 报表编号
    ,state varchar2(1) -- 状态
    ,altertimes number(22) -- 修改次数
    ,remark varchar2(200) -- 附注
    ,alterdate varchar2(10) -- 最近修改时间
    ,regioncode varchar2(4) -- 地区号
    ,repperiod varchar2(1) -- 报表周期
    ,reptype varchar2(1) -- 财务报表类型：0一般企业新会计准则；1一般企业旧会计准则；2事业单位
    ,isaudit varchar2(1) -- 是否审计：1审计 0未审计
    ,start_dt date -- 开始时间
    ,end_dt date -- 结束时间
    ,id_mark varchar2(10) -- 增删标志
    ,etl_timestamp timestamp -- ETL处理时间戳
)
partition by range(end_dt)(
    partition p_19000101 values less than (to_date('20991231','yyyymmdd'))
    ,partition p_20991231 values less than (maxvalue)
)
storage (initial 1024k next 1024k)
compress ${option_switch} for query high
nologging
;

-- grant
grant select on ${iol_schema}.nrrs_ci_repdatalist to ${iml_schema};
grant select on ${iol_schema}.nrrs_ci_repdatalist to ${icl_schema};
grant select on ${iol_schema}.nrrs_ci_repdatalist to ${idl_schema};
grant select on ${iol_schema}.nrrs_ci_repdatalist to ${iel_schema};

-- comment
comment on table ${iol_schema}.nrrs_ci_repdatalist is '财务报表明细状态';
comment on column ${iol_schema}.nrrs_ci_repdatalist.custid is '客户号';
comment on column ${iol_schema}.nrrs_ci_repdatalist.repno is '报表期数';
comment on column ${iol_schema}.nrrs_ci_repdatalist.caliber is '报表口径';
comment on column ${iol_schema}.nrrs_ci_repdatalist.frepcode is '报表编号';
comment on column ${iol_schema}.nrrs_ci_repdatalist.state is '状态';
comment on column ${iol_schema}.nrrs_ci_repdatalist.altertimes is '修改次数';
comment on column ${iol_schema}.nrrs_ci_repdatalist.remark is '附注';
comment on column ${iol_schema}.nrrs_ci_repdatalist.alterdate is '最近修改时间';
comment on column ${iol_schema}.nrrs_ci_repdatalist.regioncode is '地区号';
comment on column ${iol_schema}.nrrs_ci_repdatalist.repperiod is '报表周期';
comment on column ${iol_schema}.nrrs_ci_repdatalist.reptype is '财务报表类型：0一般企业新会计准则；1一般企业旧会计准则；2事业单位';
comment on column ${iol_schema}.nrrs_ci_repdatalist.isaudit is '是否审计：1审计 0未审计';
comment on column ${iol_schema}.nrrs_ci_repdatalist.start_dt is '开始时间';
comment on column ${iol_schema}.nrrs_ci_repdatalist.end_dt is '结束时间';
comment on column ${iol_schema}.nrrs_ci_repdatalist.id_mark is '增删标志';
comment on column ${iol_schema}.nrrs_ci_repdatalist.etl_timestamp is 'ETL处理时间戳';
