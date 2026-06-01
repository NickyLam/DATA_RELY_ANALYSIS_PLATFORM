/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol amis_ac_exe_punishment
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.amis_ac_exe_punishment
whenever sqlerror continue none;
drop table ${iol_schema}.amis_ac_exe_punishment purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.amis_ac_exe_punishment(
    ac_exe_punishment_uuid varchar2(96) -- 执行处分uuid
    ,ac_punishment_uuid varchar2(96) -- 处分录入uuid,关联处分录入uuid
    ,exe_status_code varchar2(96) -- 执行标志code;1完全执行、0待执行、2部分执行、3无法执行
    ,exe_status_name varchar2(384) -- 执行标志
    ,exe_date timestamp -- 执行时间
    ,penalty_amount number(16,2) -- 处罚金额;涉及经济处罚的且为已执行（完全执行、部分执行），填列具体金额，金额需大于等于0，默认为空，单位元
    ,create_person_uuid varchar2(96) -- 处分录入人uuid
    ,create_person_name varchar2(96) -- 处分录入人名称
    ,create_date timestamp -- 处分录入时间
    ,create_org_uuid varchar2(96) -- 处分录入机构uuid
    ,create_org_name varchar2(384) -- 处分录入机构
    ,deleted number(1,0) -- 删除标识;0未删除 1删除
    ,exe_ext1 varchar2(384) -- 扩展字段1
    ,exe_ext2 varchar2(384) -- 扩展字段2
    ,exe_ext3 varchar2(384) -- 扩展字段3
    ,exe_ext4 varchar2(384) -- 扩展字段4
    ,exe_ext5 varchar2(384) -- 扩展字段5
    ,status number(1,0) -- 状态;1草稿2审核中3审核完成4退回
    ,reason varchar2(3000) -- 原因描述
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
grant select on ${iol_schema}.amis_ac_exe_punishment to ${iml_schema};
grant select on ${iol_schema}.amis_ac_exe_punishment to ${icl_schema};
grant select on ${iol_schema}.amis_ac_exe_punishment to ${idl_schema};
grant select on ${iol_schema}.amis_ac_exe_punishment to ${iel_schema};

-- comment
comment on table ${iol_schema}.amis_ac_exe_punishment is '问责项目处分执行表';
comment on column ${iol_schema}.amis_ac_exe_punishment.ac_exe_punishment_uuid is '执行处分uuid';
comment on column ${iol_schema}.amis_ac_exe_punishment.ac_punishment_uuid is '处分录入uuid,关联处分录入uuid';
comment on column ${iol_schema}.amis_ac_exe_punishment.exe_status_code is '执行标志code;1完全执行、0待执行、2部分执行、3无法执行';
comment on column ${iol_schema}.amis_ac_exe_punishment.exe_status_name is '执行标志';
comment on column ${iol_schema}.amis_ac_exe_punishment.exe_date is '执行时间';
comment on column ${iol_schema}.amis_ac_exe_punishment.penalty_amount is '处罚金额;涉及经济处罚的且为已执行（完全执行、部分执行），填列具体金额，金额需大于等于0，默认为空，单位元';
comment on column ${iol_schema}.amis_ac_exe_punishment.create_person_uuid is '处分录入人uuid';
comment on column ${iol_schema}.amis_ac_exe_punishment.create_person_name is '处分录入人名称';
comment on column ${iol_schema}.amis_ac_exe_punishment.create_date is '处分录入时间';
comment on column ${iol_schema}.amis_ac_exe_punishment.create_org_uuid is '处分录入机构uuid';
comment on column ${iol_schema}.amis_ac_exe_punishment.create_org_name is '处分录入机构';
comment on column ${iol_schema}.amis_ac_exe_punishment.deleted is '删除标识;0未删除 1删除';
comment on column ${iol_schema}.amis_ac_exe_punishment.exe_ext1 is '扩展字段1';
comment on column ${iol_schema}.amis_ac_exe_punishment.exe_ext2 is '扩展字段2';
comment on column ${iol_schema}.amis_ac_exe_punishment.exe_ext3 is '扩展字段3';
comment on column ${iol_schema}.amis_ac_exe_punishment.exe_ext4 is '扩展字段4';
comment on column ${iol_schema}.amis_ac_exe_punishment.exe_ext5 is '扩展字段5';
comment on column ${iol_schema}.amis_ac_exe_punishment.status is '状态;1草稿2审核中3审核完成4退回';
comment on column ${iol_schema}.amis_ac_exe_punishment.reason is '原因描述';
comment on column ${iol_schema}.amis_ac_exe_punishment.start_dt is '开始时间';
comment on column ${iol_schema}.amis_ac_exe_punishment.end_dt is '结束时间';
comment on column ${iol_schema}.amis_ac_exe_punishment.id_mark is '增删标志';
comment on column ${iol_schema}.amis_ac_exe_punishment.etl_timestamp is 'ETL处理时间戳';
