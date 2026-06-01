/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol cchs_sys_dictionary_info
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.cchs_sys_dictionary_info
whenever sqlerror continue none;
drop table ${iol_schema}.cchs_sys_dictionary_info purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.cchs_sys_dictionary_info(
    code varchar2(100) -- 参数编码
    ,value varchar2(400) -- 参数值
    ,description varchar2(2000) -- 参数描述
    ,order_no varchar2(10) -- 序号
    ,status varchar2(4) -- 状态
    ,update_date date -- 更新日期
    ,create_date date -- 创建日期
    ,code_path varchar2(300) -- 参数编码路径
    ,has_child varchar2(2) -- 是否有子节点 0:NO  1:YES
    ,editable varchar2(2) -- 是否可编辑 0:NO  1:YES
    ,creater_code varchar2(30) -- 创建者工号
    ,update_code varchar2(30) -- 更新者工号
    ,id varchar2(22) -- 主键ID
    ,parent_id varchar2(22) -- 父级ID
    ,busstype number -- 1 ：系统参数 2 技术参数；  3 业务参数
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
grant select on ${iol_schema}.cchs_sys_dictionary_info to ${iml_schema};
grant select on ${iol_schema}.cchs_sys_dictionary_info to ${icl_schema};
grant select on ${iol_schema}.cchs_sys_dictionary_info to ${idl_schema};
grant select on ${iol_schema}.cchs_sys_dictionary_info to ${iel_schema};

-- comment
comment on table ${iol_schema}.cchs_sys_dictionary_info is '参数字典表';
comment on column ${iol_schema}.cchs_sys_dictionary_info.code is '参数编码';
comment on column ${iol_schema}.cchs_sys_dictionary_info.value is '参数值';
comment on column ${iol_schema}.cchs_sys_dictionary_info.description is '参数描述';
comment on column ${iol_schema}.cchs_sys_dictionary_info.order_no is '序号';
comment on column ${iol_schema}.cchs_sys_dictionary_info.status is '状态';
comment on column ${iol_schema}.cchs_sys_dictionary_info.update_date is '更新日期';
comment on column ${iol_schema}.cchs_sys_dictionary_info.create_date is '创建日期';
comment on column ${iol_schema}.cchs_sys_dictionary_info.code_path is '参数编码路径';
comment on column ${iol_schema}.cchs_sys_dictionary_info.has_child is '是否有子节点 0:NO  1:YES';
comment on column ${iol_schema}.cchs_sys_dictionary_info.editable is '是否可编辑 0:NO  1:YES';
comment on column ${iol_schema}.cchs_sys_dictionary_info.creater_code is '创建者工号';
comment on column ${iol_schema}.cchs_sys_dictionary_info.update_code is '更新者工号';
comment on column ${iol_schema}.cchs_sys_dictionary_info.id is '主键ID';
comment on column ${iol_schema}.cchs_sys_dictionary_info.parent_id is '父级ID';
comment on column ${iol_schema}.cchs_sys_dictionary_info.busstype is '1 ：系统参数 2 技术参数；  3 业务参数';
comment on column ${iol_schema}.cchs_sys_dictionary_info.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.cchs_sys_dictionary_info.etl_timestamp is 'ETL处理时间戳';
