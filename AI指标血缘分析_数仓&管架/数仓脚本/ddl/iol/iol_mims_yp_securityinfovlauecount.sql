/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol mims_yp_securityinfovlauecount
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.mims_yp_securityinfovlauecount
whenever sqlerror continue none;
drop table ${iol_schema}.mims_yp_securityinfovlauecount purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.mims_yp_securityinfovlauecount(
    businessinsid varchar2(48) -- 流程实例号
    ,sccode varchar2(48) -- 押品编号
    ,guartype varchar2(30) -- 押品类型
    ,confmamt number(20,2) -- 我行确认价值
    ,confmcurrency varchar2(5) -- 我行确认价值币种
    ,state varchar2(3) -- 出入库状态
    ,busovetime varchar2(15) -- 出入库时间
    ,createuser varchar2(30) -- 创建人
    ,deptcode varchar2(30) -- 所属机构
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
grant select on ${iol_schema}.mims_yp_securityinfovlauecount to ${iml_schema};
grant select on ${iol_schema}.mims_yp_securityinfovlauecount to ${icl_schema};
grant select on ${iol_schema}.mims_yp_securityinfovlauecount to ${idl_schema};
grant select on ${iol_schema}.mims_yp_securityinfovlauecount to ${iel_schema};

-- comment
comment on table ${iol_schema}.mims_yp_securityinfovlauecount is '押品出入库台账流水表';
comment on column ${iol_schema}.mims_yp_securityinfovlauecount.businessinsid is '流程实例号';
comment on column ${iol_schema}.mims_yp_securityinfovlauecount.sccode is '押品编号';
comment on column ${iol_schema}.mims_yp_securityinfovlauecount.guartype is '押品类型';
comment on column ${iol_schema}.mims_yp_securityinfovlauecount.confmamt is '我行确认价值';
comment on column ${iol_schema}.mims_yp_securityinfovlauecount.confmcurrency is '我行确认价值币种';
comment on column ${iol_schema}.mims_yp_securityinfovlauecount.state is '出入库状态';
comment on column ${iol_schema}.mims_yp_securityinfovlauecount.busovetime is '出入库时间';
comment on column ${iol_schema}.mims_yp_securityinfovlauecount.createuser is '创建人';
comment on column ${iol_schema}.mims_yp_securityinfovlauecount.deptcode is '所属机构';
comment on column ${iol_schema}.mims_yp_securityinfovlauecount.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.mims_yp_securityinfovlauecount.etl_timestamp is 'ETL处理时间戳';
