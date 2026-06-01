/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol osbs_bas_im_service_trans_rel
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.osbs_bas_im_service_trans_rel
whenever sqlerror continue none;
drop table ${iol_schema}.osbs_bas_im_service_trans_rel purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.osbs_bas_im_service_trans_rel(
    bst_serviceid varchar2(20) -- 服务编号(ATS-鉴权服务PBS-对私服务CPR-对公服务TPS-转账服务FLS-金融生活)
    ,bst_transid varchar2(50) -- 交易编号
    ,bst_transname varchar2(150) -- 交易名称
    ,bst_transdiaplsy varchar2(4) -- 交易设定(4位，1-是，0-否。第1位：是否有交易明细；2：预留；3：预留；4：预留)
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
grant select on ${iol_schema}.osbs_bas_im_service_trans_rel to ${iml_schema};
grant select on ${iol_schema}.osbs_bas_im_service_trans_rel to ${icl_schema};
grant select on ${iol_schema}.osbs_bas_im_service_trans_rel to ${idl_schema};
grant select on ${iol_schema}.osbs_bas_im_service_trans_rel to ${iel_schema};

-- comment
comment on table ${iol_schema}.osbs_bas_im_service_trans_rel is '服务交易关联表';
comment on column ${iol_schema}.osbs_bas_im_service_trans_rel.bst_serviceid is '服务编号(ATS-鉴权服务PBS-对私服务CPR-对公服务TPS-转账服务FLS-金融生活)';
comment on column ${iol_schema}.osbs_bas_im_service_trans_rel.bst_transid is '交易编号';
comment on column ${iol_schema}.osbs_bas_im_service_trans_rel.bst_transname is '交易名称';
comment on column ${iol_schema}.osbs_bas_im_service_trans_rel.bst_transdiaplsy is '交易设定(4位，1-是，0-否。第1位：是否有交易明细；2：预留；3：预留；4：预留)';
comment on column ${iol_schema}.osbs_bas_im_service_trans_rel.start_dt is '开始时间';
comment on column ${iol_schema}.osbs_bas_im_service_trans_rel.end_dt is '结束时间';
comment on column ${iol_schema}.osbs_bas_im_service_trans_rel.id_mark is '增删标志';
comment on column ${iol_schema}.osbs_bas_im_service_trans_rel.etl_timestamp is 'ETL处理时间戳';
