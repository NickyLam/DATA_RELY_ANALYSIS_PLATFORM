/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol iers_fip_relation
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.iers_fip_relation
whenever sqlerror continue none;
drop table ${iol_schema}.iers_fip_relation purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.iers_fip_relation(
    batchno varchar2(30) -- 
    ,busimessage1 varchar2(600) -- 业务关联信息1
    ,busimessage2 varchar2(600) -- 业务关联信息2
    ,busimessage3 varchar2(600) -- 业务关联信息3
    ,des_billtype varchar2(30) -- 目标单据类型
    ,des_busidate varchar2(29) -- 目标业务日期
    ,des_defdoc1 varchar2(152) -- 目标分组档案1
    ,des_defdoc2 varchar2(152) -- 目标分组档案2
    ,des_defdoc3 varchar2(152) -- 目标分组档案3
    ,des_freedef1 varchar2(300) -- 目标辅助信息1
    ,des_freedef2 varchar2(3000) -- 目标辅助信息2
    ,des_freedef3 varchar2(300) -- 目标辅助信息3
    ,des_freedef4 varchar2(300) -- 目标辅助信息4
    ,des_freedef5 varchar2(300) -- 目标辅助信息5
    ,des_group varchar2(30) -- 目标集团
    ,des_operator varchar2(30) -- 目标操作员
    ,des_org varchar2(30) -- 目标组织
    ,des_relationid varchar2(75) -- 目标单据关联号
    ,des_system varchar2(75) -- 目标系统
    ,dr number(10,0) -- 删除标志
    ,pk_relation varchar2(30) -- 对象标识
    ,saga_btxid varchar2(96) -- 
    ,saga_frozen number(38,0) -- 
    ,saga_gtxid varchar2(96) -- 
    ,saga_status number(38,0) -- 
    ,src_billtype varchar2(30) -- 来源单据类型
    ,src_busidate varchar2(29) -- 来源业务日期
    ,src_defdoc1 varchar2(152) -- 来源分组档案1
    ,src_defdoc2 varchar2(152) -- 来源分组档案2
    ,src_defdoc3 varchar2(152) -- 来源分组档案3
    ,src_freedef1 varchar2(300) -- 来源辅助信息1
    ,src_freedef2 varchar2(300) -- 来源辅助信息2
    ,src_freedef3 varchar2(300) -- 来源辅助信息3
    ,src_freedef4 varchar2(300) -- 来源辅助信息4
    ,src_freedef5 varchar2(300) -- 来源辅助信息5
    ,src_group varchar2(30) -- 来源集团
    ,src_operator varchar2(30) -- 来源操作员
    ,src_org varchar2(30) -- 来源组织
    ,src_relationid varchar2(75) -- 来源单据关联号
    ,src_system varchar2(75) -- 来源系统
    ,sumflag varchar2(2) -- 来源单据是否汇总
    ,ts varchar2(29) -- 时间戳
    ,start_dt date -- 开始时间
    ,end_dt date -- 结束时间
    ,id_mark varchar2(10) -- 增删标志
    ,etl_timestamp timestamp -- ETL处理时间戳
)
partition by list(end_dt)(
     partition p_19000101 values (to_date('19000101','yyyymmdd')),
     partition p_20991231 values (to_date('20991231','yyyymmdd'))
)
storage (initial 1024k next 1024k)
compress ${option_switch} for query high
nologging
;

-- grant
grant select on ${iol_schema}.iers_fip_relation to ${iml_schema};
grant select on ${iol_schema}.iers_fip_relation to ${icl_schema};
grant select on ${iol_schema}.iers_fip_relation to ${idl_schema};
grant select on ${iol_schema}.iers_fip_relation to ${iel_schema};

-- comment
comment on table ${iol_schema}.iers_fip_relation is '单据与凭证关联关系表';
comment on column ${iol_schema}.iers_fip_relation.batchno is '';
comment on column ${iol_schema}.iers_fip_relation.busimessage1 is '业务关联信息1';
comment on column ${iol_schema}.iers_fip_relation.busimessage2 is '业务关联信息2';
comment on column ${iol_schema}.iers_fip_relation.busimessage3 is '业务关联信息3';
comment on column ${iol_schema}.iers_fip_relation.des_billtype is '目标单据类型';
comment on column ${iol_schema}.iers_fip_relation.des_busidate is '目标业务日期';
comment on column ${iol_schema}.iers_fip_relation.des_defdoc1 is '目标分组档案1';
comment on column ${iol_schema}.iers_fip_relation.des_defdoc2 is '目标分组档案2';
comment on column ${iol_schema}.iers_fip_relation.des_defdoc3 is '目标分组档案3';
comment on column ${iol_schema}.iers_fip_relation.des_freedef1 is '目标辅助信息1';
comment on column ${iol_schema}.iers_fip_relation.des_freedef2 is '目标辅助信息2';
comment on column ${iol_schema}.iers_fip_relation.des_freedef3 is '目标辅助信息3';
comment on column ${iol_schema}.iers_fip_relation.des_freedef4 is '目标辅助信息4';
comment on column ${iol_schema}.iers_fip_relation.des_freedef5 is '目标辅助信息5';
comment on column ${iol_schema}.iers_fip_relation.des_group is '目标集团';
comment on column ${iol_schema}.iers_fip_relation.des_operator is '目标操作员';
comment on column ${iol_schema}.iers_fip_relation.des_org is '目标组织';
comment on column ${iol_schema}.iers_fip_relation.des_relationid is '目标单据关联号';
comment on column ${iol_schema}.iers_fip_relation.des_system is '目标系统';
comment on column ${iol_schema}.iers_fip_relation.dr is '删除标志';
comment on column ${iol_schema}.iers_fip_relation.pk_relation is '对象标识';
comment on column ${iol_schema}.iers_fip_relation.saga_btxid is '';
comment on column ${iol_schema}.iers_fip_relation.saga_frozen is '';
comment on column ${iol_schema}.iers_fip_relation.saga_gtxid is '';
comment on column ${iol_schema}.iers_fip_relation.saga_status is '';
comment on column ${iol_schema}.iers_fip_relation.src_billtype is '来源单据类型';
comment on column ${iol_schema}.iers_fip_relation.src_busidate is '来源业务日期';
comment on column ${iol_schema}.iers_fip_relation.src_defdoc1 is '来源分组档案1';
comment on column ${iol_schema}.iers_fip_relation.src_defdoc2 is '来源分组档案2';
comment on column ${iol_schema}.iers_fip_relation.src_defdoc3 is '来源分组档案3';
comment on column ${iol_schema}.iers_fip_relation.src_freedef1 is '来源辅助信息1';
comment on column ${iol_schema}.iers_fip_relation.src_freedef2 is '来源辅助信息2';
comment on column ${iol_schema}.iers_fip_relation.src_freedef3 is '来源辅助信息3';
comment on column ${iol_schema}.iers_fip_relation.src_freedef4 is '来源辅助信息4';
comment on column ${iol_schema}.iers_fip_relation.src_freedef5 is '来源辅助信息5';
comment on column ${iol_schema}.iers_fip_relation.src_group is '来源集团';
comment on column ${iol_schema}.iers_fip_relation.src_operator is '来源操作员';
comment on column ${iol_schema}.iers_fip_relation.src_org is '来源组织';
comment on column ${iol_schema}.iers_fip_relation.src_relationid is '来源单据关联号';
comment on column ${iol_schema}.iers_fip_relation.src_system is '来源系统';
comment on column ${iol_schema}.iers_fip_relation.sumflag is '来源单据是否汇总';
comment on column ${iol_schema}.iers_fip_relation.ts is '时间戳';
comment on column ${iol_schema}.iers_fip_relation.start_dt is '开始时间';
comment on column ${iol_schema}.iers_fip_relation.end_dt is '结束时间';
comment on column ${iol_schema}.iers_fip_relation.id_mark is '增删标志';
comment on column ${iol_schema}.iers_fip_relation.etl_timestamp is 'ETL处理时间戳';
