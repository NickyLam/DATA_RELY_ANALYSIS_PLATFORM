/*
Purpose:    整合模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iml agt_pasct_turn_crdt_info_h
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iml_schema}.agt_pasct_turn_crdt_info_h
whenever sqlerror continue none;
drop table ${iml_schema}.agt_pasct_turn_crdt_info_h purge;

whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.agt_pasct_turn_crdt_info_h(
    agt_id varchar2(250) -- 协议编号
    ,lp_id varchar2(100) -- 法人编号
    ,turn_crdt_id varchar2(100) -- 转授信编号
    ,obj_id varchar2(100) -- 对象编号
    ,obj_type_name varchar2(60) -- 对象类型名称
    ,init_obj_id varchar2(100) -- 原对象编号
    ,init_obj_type_name varchar2(60) -- 原对象类型名称
    ,approve_serial_flow_num varchar2(100) -- 被动转授信集团批复流水号
    ,beads_flg varchar2(10) -- 串用标志
    ,lmt_src_cd varchar2(30) -- 额度来源代码
    ,circl_flg varchar2(10) -- 循环标志
    ,update_teller_id varchar2(100) -- 更新柜员编号
    ,modif_dt date -- 变更日期
    ,update_org_id varchar2(100) -- 更新机构编号
    ,rgst_teller_id varchar2(100) -- 登记柜员编号
    ,rgst_dt date -- 登记日期
    ,rgst_org_id varchar2(100) -- 登记机构编号
    ,start_dt date -- 开始时间
    ,end_dt date -- 结束时间
    ,id_mark varchar2(10) -- 增删标志
    ,src_table_name varchar2(100) -- 源表名称
    ,job_cd varchar2(10) -- 任务编码
    ,etl_timestamp timestamp -- ETL处理时间戳
)
partition by list (job_cd)
subpartition by list (end_dt)
(
   partition p_default values ('default')
   (
         subpartition p_default_19000101 values (to_date('19000101','yyyymmdd'))
         ,subpartition p_default_20991231 values (to_date('20991231','yyyymmdd'))
   )
)
storage (initial 1024k next 1024k)
compress ${option_switch} for query high
nologging
;

-- grant
grant select on ${iml_schema}.agt_pasct_turn_crdt_info_h to ${icl_schema};
grant select on ${iml_schema}.agt_pasct_turn_crdt_info_h to ${idl_schema};
grant select on ${iml_schema}.agt_pasct_turn_crdt_info_h to ${iel_schema};

-- comment
comment on table ${iml_schema}.agt_pasct_turn_crdt_info_h is '被动转授信信息历史';
comment on column ${iml_schema}.agt_pasct_turn_crdt_info_h.agt_id is '协议编号';
comment on column ${iml_schema}.agt_pasct_turn_crdt_info_h.lp_id is '法人编号';
comment on column ${iml_schema}.agt_pasct_turn_crdt_info_h.turn_crdt_id is '转授信编号';
comment on column ${iml_schema}.agt_pasct_turn_crdt_info_h.obj_id is '对象编号';
comment on column ${iml_schema}.agt_pasct_turn_crdt_info_h.obj_type_name is '对象类型名称';
comment on column ${iml_schema}.agt_pasct_turn_crdt_info_h.init_obj_id is '原对象编号';
comment on column ${iml_schema}.agt_pasct_turn_crdt_info_h.init_obj_type_name is '原对象类型名称';
comment on column ${iml_schema}.agt_pasct_turn_crdt_info_h.approve_serial_flow_num is '被动转授信集团批复流水号';
comment on column ${iml_schema}.agt_pasct_turn_crdt_info_h.beads_flg is '串用标志';
comment on column ${iml_schema}.agt_pasct_turn_crdt_info_h.lmt_src_cd is '额度来源代码';
comment on column ${iml_schema}.agt_pasct_turn_crdt_info_h.circl_flg is '循环标志';
comment on column ${iml_schema}.agt_pasct_turn_crdt_info_h.update_teller_id is '更新柜员编号';
comment on column ${iml_schema}.agt_pasct_turn_crdt_info_h.modif_dt is '变更日期';
comment on column ${iml_schema}.agt_pasct_turn_crdt_info_h.update_org_id is '更新机构编号';
comment on column ${iml_schema}.agt_pasct_turn_crdt_info_h.rgst_teller_id is '登记柜员编号';
comment on column ${iml_schema}.agt_pasct_turn_crdt_info_h.rgst_dt is '登记日期';
comment on column ${iml_schema}.agt_pasct_turn_crdt_info_h.rgst_org_id is '登记机构编号';
comment on column ${iml_schema}.agt_pasct_turn_crdt_info_h.start_dt is '开始时间';
comment on column ${iml_schema}.agt_pasct_turn_crdt_info_h.end_dt is '结束时间';
comment on column ${iml_schema}.agt_pasct_turn_crdt_info_h.id_mark is '增删标志';
comment on column ${iml_schema}.agt_pasct_turn_crdt_info_h.src_table_name is '源表名称';
comment on column ${iml_schema}.agt_pasct_turn_crdt_info_h.job_cd is '任务编码';
comment on column ${iml_schema}.agt_pasct_turn_crdt_info_h.etl_timestamp is 'ETL处理时间戳';
