/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol eifs_t01_pub_merger_split_reg
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.eifs_t01_pub_merger_split_reg
whenever sqlerror continue none;
drop table ${iol_schema}.eifs_t01_pub_merger_split_reg purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.eifs_t01_pub_merger_split_reg(
    exchange_id varchar2(45) -- 修改编号
    ,left_party_id varchar2(45) -- 保留方party_id
    ,left_cust_no varchar2(24) -- 保留方客户号
    ,left_blg_org varchar2(15) -- 保留方归属机构
    ,left_cust_name varchar2(150) -- 保留方客户名称
    ,left_cert_type varchar2(11) -- 保留方证件类型
    ,left_cert_no varchar2(270) -- 保留方证件号码
    ,merged_party_id varchar2(45) -- 被归并方party_id
    ,merged_cust_no varchar2(24) -- 被归并方客户号
    ,merged_blg_org varchar2(15) -- 被归并客户归属机构
    ,merged_cust_name varchar2(150) -- 被归并方客户名称
    ,merged_cert_type varchar2(11) -- 被归并方证件类型
    ,merged_cert_no varchar2(270) -- 被归并方证件号码
    ,merged_state varchar2(15) -- 归并状态
    ,merged_date varchar2(15) -- 归并日期
    ,merged_org varchar2(15) -- 归并机构
    ,merged_te varchar2(15) -- 归并柜员
    ,split_date varchar2(15) -- 拆分日期
    ,split_org varchar2(15) -- 拆分机构
    ,split_te varchar2(15) -- 拆分柜员
    ,create_te varchar2(12) -- 创建柜员
    ,create_org varchar2(15) -- 创建机构号
    ,init_system_id varchar2(15) -- 创建渠道
    ,init_created_ts timestamp -- 源系统创建时间
    ,created_ts timestamp -- 进入ecif的时间
    ,updated_ts timestamp -- 在ecif中失效的时间
    ,last_updated_te varchar2(45) -- 最新更新柜员
    ,last_updated_org varchar2(30) -- 最新更新机构号
    ,last_system_id varchar2(15) -- 最新更新渠道
    ,last_updated_ts timestamp -- 最新更新时间
    ,src_sys_num varchar2(45) -- 来源系统编号
    ,last_updated_src_sys_num varchar2(45) -- 最新更新源系统编号
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
grant select on ${iol_schema}.eifs_t01_pub_merger_split_reg to ${iml_schema};
grant select on ${iol_schema}.eifs_t01_pub_merger_split_reg to ${icl_schema};
grant select on ${iol_schema}.eifs_t01_pub_merger_split_reg to ${idl_schema};
grant select on ${iol_schema}.eifs_t01_pub_merger_split_reg to ${iel_schema};

-- comment
comment on table ${iol_schema}.eifs_t01_pub_merger_split_reg is '客户归并拆分登记表';
comment on column ${iol_schema}.eifs_t01_pub_merger_split_reg.exchange_id is '修改编号';
comment on column ${iol_schema}.eifs_t01_pub_merger_split_reg.left_party_id is '保留方party_id';
comment on column ${iol_schema}.eifs_t01_pub_merger_split_reg.left_cust_no is '保留方客户号';
comment on column ${iol_schema}.eifs_t01_pub_merger_split_reg.left_blg_org is '保留方归属机构';
comment on column ${iol_schema}.eifs_t01_pub_merger_split_reg.left_cust_name is '保留方客户名称';
comment on column ${iol_schema}.eifs_t01_pub_merger_split_reg.left_cert_type is '保留方证件类型';
comment on column ${iol_schema}.eifs_t01_pub_merger_split_reg.left_cert_no is '保留方证件号码';
comment on column ${iol_schema}.eifs_t01_pub_merger_split_reg.merged_party_id is '被归并方party_id';
comment on column ${iol_schema}.eifs_t01_pub_merger_split_reg.merged_cust_no is '被归并方客户号';
comment on column ${iol_schema}.eifs_t01_pub_merger_split_reg.merged_blg_org is '被归并客户归属机构';
comment on column ${iol_schema}.eifs_t01_pub_merger_split_reg.merged_cust_name is '被归并方客户名称';
comment on column ${iol_schema}.eifs_t01_pub_merger_split_reg.merged_cert_type is '被归并方证件类型';
comment on column ${iol_schema}.eifs_t01_pub_merger_split_reg.merged_cert_no is '被归并方证件号码';
comment on column ${iol_schema}.eifs_t01_pub_merger_split_reg.merged_state is '归并状态';
comment on column ${iol_schema}.eifs_t01_pub_merger_split_reg.merged_date is '归并日期';
comment on column ${iol_schema}.eifs_t01_pub_merger_split_reg.merged_org is '归并机构';
comment on column ${iol_schema}.eifs_t01_pub_merger_split_reg.merged_te is '归并柜员';
comment on column ${iol_schema}.eifs_t01_pub_merger_split_reg.split_date is '拆分日期';
comment on column ${iol_schema}.eifs_t01_pub_merger_split_reg.split_org is '拆分机构';
comment on column ${iol_schema}.eifs_t01_pub_merger_split_reg.split_te is '拆分柜员';
comment on column ${iol_schema}.eifs_t01_pub_merger_split_reg.create_te is '创建柜员';
comment on column ${iol_schema}.eifs_t01_pub_merger_split_reg.create_org is '创建机构号';
comment on column ${iol_schema}.eifs_t01_pub_merger_split_reg.init_system_id is '创建渠道';
comment on column ${iol_schema}.eifs_t01_pub_merger_split_reg.init_created_ts is '源系统创建时间';
comment on column ${iol_schema}.eifs_t01_pub_merger_split_reg.created_ts is '进入ecif的时间';
comment on column ${iol_schema}.eifs_t01_pub_merger_split_reg.updated_ts is '在ecif中失效的时间';
comment on column ${iol_schema}.eifs_t01_pub_merger_split_reg.last_updated_te is '最新更新柜员';
comment on column ${iol_schema}.eifs_t01_pub_merger_split_reg.last_updated_org is '最新更新机构号';
comment on column ${iol_schema}.eifs_t01_pub_merger_split_reg.last_system_id is '最新更新渠道';
comment on column ${iol_schema}.eifs_t01_pub_merger_split_reg.last_updated_ts is '最新更新时间';
comment on column ${iol_schema}.eifs_t01_pub_merger_split_reg.src_sys_num is '来源系统编号';
comment on column ${iol_schema}.eifs_t01_pub_merger_split_reg.last_updated_src_sys_num is '最新更新源系统编号';
comment on column ${iol_schema}.eifs_t01_pub_merger_split_reg.start_dt is '开始时间';
comment on column ${iol_schema}.eifs_t01_pub_merger_split_reg.end_dt is '结束时间';
comment on column ${iol_schema}.eifs_t01_pub_merger_split_reg.id_mark is '增删标志';
comment on column ${iol_schema}.eifs_t01_pub_merger_split_reg.etl_timestamp is 'ETL处理时间戳';
