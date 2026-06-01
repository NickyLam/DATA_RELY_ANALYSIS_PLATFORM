/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol svss_svs_accadm_sealcard
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.svss_svs_accadm_sealcard
whenever sqlerror continue none;
drop table ${iol_schema}.svss_svs_accadm_sealcard purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.svss_svs_accadm_sealcard(
    id varchar2(48) -- 序号
    ,acc_id varchar2(48) -- 所属账户ID
    ,seal_count number(22,0) -- 印鉴枚数
    ,start_date varchar2(48) -- 印鉴卡启用时间
    ,end_date varchar2(48) -- 印鉴卡注销日期
    ,memo varchar2(768) -- 备注
    ,card_no varchar2(48) -- 印鉴卡号
    ,acc_no varchar2(48) -- 所属账户的账号
    ,crud_flag number(22,0) -- 印鉴卡的状态
    ,image_ids varchar2(3072) -- 印鉴卡图像索引组
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
grant select on ${iol_schema}.svss_svs_accadm_sealcard to ${iml_schema};
grant select on ${iol_schema}.svss_svs_accadm_sealcard to ${icl_schema};
grant select on ${iol_schema}.svss_svs_accadm_sealcard to ${idl_schema};
grant select on ${iol_schema}.svss_svs_accadm_sealcard to ${iel_schema};

-- comment
comment on table ${iol_schema}.svss_svs_accadm_sealcard is '验印印鉴卡信息表';
comment on column ${iol_schema}.svss_svs_accadm_sealcard.id is '序号';
comment on column ${iol_schema}.svss_svs_accadm_sealcard.acc_id is '所属账户ID';
comment on column ${iol_schema}.svss_svs_accadm_sealcard.seal_count is '印鉴枚数';
comment on column ${iol_schema}.svss_svs_accadm_sealcard.start_date is '印鉴卡启用时间';
comment on column ${iol_schema}.svss_svs_accadm_sealcard.end_date is '印鉴卡注销日期';
comment on column ${iol_schema}.svss_svs_accadm_sealcard.memo is '备注';
comment on column ${iol_schema}.svss_svs_accadm_sealcard.card_no is '印鉴卡号';
comment on column ${iol_schema}.svss_svs_accadm_sealcard.acc_no is '所属账户的账号';
comment on column ${iol_schema}.svss_svs_accadm_sealcard.crud_flag is '印鉴卡的状态';
comment on column ${iol_schema}.svss_svs_accadm_sealcard.image_ids is '印鉴卡图像索引组';
comment on column ${iol_schema}.svss_svs_accadm_sealcard.start_dt is '开始时间';
comment on column ${iol_schema}.svss_svs_accadm_sealcard.end_dt is '结束时间';
comment on column ${iol_schema}.svss_svs_accadm_sealcard.id_mark is '增删标志';
comment on column ${iol_schema}.svss_svs_accadm_sealcard.etl_timestamp is 'ETL处理时间戳';
