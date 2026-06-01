/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol rptm_rtm_rp_his_natural
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.rptm_rtm_rp_his_natural
whenever sqlerror continue none;
drop table ${iol_schema}.rptm_rtm_rp_his_natural purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.rptm_rtm_rp_his_natural(
    id varchar2(48) -- ID
    ,bus_id varchar2(96) -- 业务主键
    ,his_bus_id varchar2(96) -- 关联的名单业务编号
    ,east_rp_type varchar2(3) -- 关联方类型-EAST报表口径
    ,ybj_rp_type varchar2(3) -- 关联方类型-银保监会口径
    ,rp_name varchar2(300) -- 关联方名称
    ,ybj_card_type varchar2(15) -- 
    ,east_card_type varchar2(3) -- 证件类型-EAST报表口径
    ,card_no varchar2(150) -- 证件号码
    ,domestic_state varchar2(3) -- 境内外
    ,rea_no varchar2(383) -- 关联方成因
    ,rea_desc varchar2(383) -- 关联方成因描述
    ,inst_org varchar2(75) -- 监管机构
    ,east_relation_type varchar2(5) -- 关联关系类型-EAST报表口径
    ,org_type varchar2(3) -- 金融机构类型
    ,bloc_state varchar2(3) -- 备用字段
    ,bloc_id varchar2(96) -- 备用字段
    ,bloc_name varchar2(300) -- 备用字段
    ,bloc_card_no varchar2(150) -- 备用字段
    ,remarks varchar2(4000) -- 备注信息
    ,data_state varchar2(3) -- 数据状态
    ,effect_state varchar2(3) -- 生效状态
    ,active_time date -- 生效时间
    ,invalid_time date -- 失效时间
    ,process_time date -- 审核通过时间
    ,data_source varchar2(3) -- 数据来源
    ,legal_org_code varchar2(383) -- 独立法人编码
    ,create_user varchar2(48) -- 创建人
    ,create_time date -- 创建时间
    ,create_org varchar2(48) -- 创建机构
    ,create_dep varchar2(48) -- 创建部门
    ,update_user varchar2(48) -- 修改人
    ,update_time date -- 修改时间
    ,update_org varchar2(48) -- 修改机构
    ,update_dep varchar2(48) -- 修改部门
    ,wf_state varchar2(3) -- 流程状态
    ,agree varchar2(1500) -- 同意标识
    ,process_instance_id varchar2(96) -- 流程实例ID
    ,reserve1 varchar2(383) -- 备用字段1
    ,reserve2 varchar2(383) -- 备用字段2
    ,reserve3 varchar2(383) -- 备用字段3
    ,data_dt date -- 数据跑批日期
    ,duty varchar2(300) -- 本行职务/岗位
    ,cust_no varchar2(96) -- 职务编号
    ,east_rp_bad_info varchar2(6) -- 不良信息-east报表口径
    ,east_rp_economic_nature varchar2(6) -- 经济性质和类型-east报表口径
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
grant select on ${iol_schema}.rptm_rtm_rp_his_natural to ${iml_schema};
grant select on ${iol_schema}.rptm_rtm_rp_his_natural to ${icl_schema};
grant select on ${iol_schema}.rptm_rtm_rp_his_natural to ${idl_schema};
grant select on ${iol_schema}.rptm_rtm_rp_his_natural to ${iel_schema};

-- comment
comment on table ${iol_schema}.rptm_rtm_rp_his_natural is '关联方历史名单-关联自然人';
comment on column ${iol_schema}.rptm_rtm_rp_his_natural.id is 'ID';
comment on column ${iol_schema}.rptm_rtm_rp_his_natural.bus_id is '业务主键';
comment on column ${iol_schema}.rptm_rtm_rp_his_natural.his_bus_id is '关联的名单业务编号';
comment on column ${iol_schema}.rptm_rtm_rp_his_natural.east_rp_type is '关联方类型-EAST报表口径';
comment on column ${iol_schema}.rptm_rtm_rp_his_natural.ybj_rp_type is '关联方类型-银保监会口径';
comment on column ${iol_schema}.rptm_rtm_rp_his_natural.rp_name is '关联方名称';
comment on column ${iol_schema}.rptm_rtm_rp_his_natural.ybj_card_type is '';
comment on column ${iol_schema}.rptm_rtm_rp_his_natural.east_card_type is '证件类型-EAST报表口径';
comment on column ${iol_schema}.rptm_rtm_rp_his_natural.card_no is '证件号码';
comment on column ${iol_schema}.rptm_rtm_rp_his_natural.domestic_state is '境内外';
comment on column ${iol_schema}.rptm_rtm_rp_his_natural.rea_no is '关联方成因';
comment on column ${iol_schema}.rptm_rtm_rp_his_natural.rea_desc is '关联方成因描述';
comment on column ${iol_schema}.rptm_rtm_rp_his_natural.inst_org is '监管机构';
comment on column ${iol_schema}.rptm_rtm_rp_his_natural.east_relation_type is '关联关系类型-EAST报表口径';
comment on column ${iol_schema}.rptm_rtm_rp_his_natural.org_type is '金融机构类型';
comment on column ${iol_schema}.rptm_rtm_rp_his_natural.bloc_state is '备用字段';
comment on column ${iol_schema}.rptm_rtm_rp_his_natural.bloc_id is '备用字段';
comment on column ${iol_schema}.rptm_rtm_rp_his_natural.bloc_name is '备用字段';
comment on column ${iol_schema}.rptm_rtm_rp_his_natural.bloc_card_no is '备用字段';
comment on column ${iol_schema}.rptm_rtm_rp_his_natural.remarks is '备注信息';
comment on column ${iol_schema}.rptm_rtm_rp_his_natural.data_state is '数据状态';
comment on column ${iol_schema}.rptm_rtm_rp_his_natural.effect_state is '生效状态';
comment on column ${iol_schema}.rptm_rtm_rp_his_natural.active_time is '生效时间';
comment on column ${iol_schema}.rptm_rtm_rp_his_natural.invalid_time is '失效时间';
comment on column ${iol_schema}.rptm_rtm_rp_his_natural.process_time is '审核通过时间';
comment on column ${iol_schema}.rptm_rtm_rp_his_natural.data_source is '数据来源';
comment on column ${iol_schema}.rptm_rtm_rp_his_natural.legal_org_code is '独立法人编码';
comment on column ${iol_schema}.rptm_rtm_rp_his_natural.create_user is '创建人';
comment on column ${iol_schema}.rptm_rtm_rp_his_natural.create_time is '创建时间';
comment on column ${iol_schema}.rptm_rtm_rp_his_natural.create_org is '创建机构';
comment on column ${iol_schema}.rptm_rtm_rp_his_natural.create_dep is '创建部门';
comment on column ${iol_schema}.rptm_rtm_rp_his_natural.update_user is '修改人';
comment on column ${iol_schema}.rptm_rtm_rp_his_natural.update_time is '修改时间';
comment on column ${iol_schema}.rptm_rtm_rp_his_natural.update_org is '修改机构';
comment on column ${iol_schema}.rptm_rtm_rp_his_natural.update_dep is '修改部门';
comment on column ${iol_schema}.rptm_rtm_rp_his_natural.wf_state is '流程状态';
comment on column ${iol_schema}.rptm_rtm_rp_his_natural.agree is '同意标识';
comment on column ${iol_schema}.rptm_rtm_rp_his_natural.process_instance_id is '流程实例ID';
comment on column ${iol_schema}.rptm_rtm_rp_his_natural.reserve1 is '备用字段1';
comment on column ${iol_schema}.rptm_rtm_rp_his_natural.reserve2 is '备用字段2';
comment on column ${iol_schema}.rptm_rtm_rp_his_natural.reserve3 is '备用字段3';
comment on column ${iol_schema}.rptm_rtm_rp_his_natural.data_dt is '数据跑批日期';
comment on column ${iol_schema}.rptm_rtm_rp_his_natural.duty is '本行职务/岗位';
comment on column ${iol_schema}.rptm_rtm_rp_his_natural.cust_no is '职务编号';
comment on column ${iol_schema}.rptm_rtm_rp_his_natural.east_rp_bad_info is '不良信息-east报表口径';
comment on column ${iol_schema}.rptm_rtm_rp_his_natural.east_rp_economic_nature is '经济性质和类型-east报表口径';
comment on column ${iol_schema}.rptm_rtm_rp_his_natural.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.rptm_rtm_rp_his_natural.etl_timestamp is 'ETL处理时间戳';
