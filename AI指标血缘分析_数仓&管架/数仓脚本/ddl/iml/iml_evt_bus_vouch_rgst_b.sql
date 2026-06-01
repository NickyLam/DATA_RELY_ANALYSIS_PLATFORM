/*
Purpose:    整合模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iml evt_bus_vouch_rgst_b
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iml_schema}.evt_bus_vouch_rgst_b
whenever sqlerror continue none;
drop table ${iml_schema}.evt_bus_vouch_rgst_b purge;

whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.evt_bus_vouch_rgst_b(
    evt_id varchar2(250) -- 事件编号
    ,lp_id varchar2(100) -- 法人编号
    ,rgst_flow_num varchar2(100) -- 登记流水号
    ,rgst_dt date -- 登记日期
    ,rgst_batch_no varchar2(60) -- 登记批次号
    ,bus_flow_num varchar2(100) -- 业务流水号
    ,chn_dt date -- 渠道日期
    ,chn_flow_num varchar2(100) -- 渠道流水号
    ,chn_cd varchar2(30) -- 渠道代码
    ,vouch_seq_num varchar2(60) -- 凭证序号
    ,vouch_type_cd varchar2(30) -- 凭证类型代码
    ,trdpty_tran_code varchar2(60) -- 第三方交易码
    ,proc_step_cd varchar2(30) -- 处理步骤代码
    ,proc_status_cd varchar2(30) -- 处理状态代码
    ,proc_cnt number(10) -- 处理次数
    ,proc_dt date -- 处理日期
    ,app_process_cd varchar2(60) -- 应用处理码
    ,app_proc_info varchar2(2000) -- 应用处理信息
    ,blip_batch_no varchar2(100) -- 影像批次号
    ,file_num_create_way_cd varchar2(30) -- 归档号生成方式代码
    ,doc_upload_status_cd varchar2(30) -- 文件上传状态代码
    ,org_id varchar2(100) -- 机构编号
    ,teller_id varchar2(100) -- 柜员编号
    ,init_create_dt date -- 最初创建日期
    ,modif_dt date -- 修改日期
    ,remark varchar2(500) -- 备注
    ,remark_2 varchar2(500) -- 备注2
    ,etl_dt date -- ETL处理日期
    ,src_table_name varchar2(100) -- 源表名称
    ,job_cd varchar2(10) -- 任务编码
    ,etl_timestamp timestamp -- ETL处理时间戳
)
partition by list (job_cd)
subpartition by list (etl_dt)
(
   partition p_default values ('default')
   (
        subpartition p_default_19000101 values (to_date('19000101','yyyymmdd'))
   )
)
storage (initial 1024k next 1024k)
compress ${option_switch} for query high
nologging
;

-- grant
grant select on ${iml_schema}.evt_bus_vouch_rgst_b to ${icl_schema};
grant select on ${iml_schema}.evt_bus_vouch_rgst_b to ${idl_schema};
grant select on ${iml_schema}.evt_bus_vouch_rgst_b to ${iel_schema};

-- comment
comment on table ${iml_schema}.evt_bus_vouch_rgst_b is '业务凭证登记簿';
comment on column ${iml_schema}.evt_bus_vouch_rgst_b.evt_id is '事件编号';
comment on column ${iml_schema}.evt_bus_vouch_rgst_b.lp_id is '法人编号';
comment on column ${iml_schema}.evt_bus_vouch_rgst_b.rgst_flow_num is '登记流水号';
comment on column ${iml_schema}.evt_bus_vouch_rgst_b.rgst_dt is '登记日期';
comment on column ${iml_schema}.evt_bus_vouch_rgst_b.rgst_batch_no is '登记批次号';
comment on column ${iml_schema}.evt_bus_vouch_rgst_b.bus_flow_num is '业务流水号';
comment on column ${iml_schema}.evt_bus_vouch_rgst_b.chn_dt is '渠道日期';
comment on column ${iml_schema}.evt_bus_vouch_rgst_b.chn_flow_num is '渠道流水号';
comment on column ${iml_schema}.evt_bus_vouch_rgst_b.chn_cd is '渠道代码';
comment on column ${iml_schema}.evt_bus_vouch_rgst_b.vouch_seq_num is '凭证序号';
comment on column ${iml_schema}.evt_bus_vouch_rgst_b.vouch_type_cd is '凭证类型代码';
comment on column ${iml_schema}.evt_bus_vouch_rgst_b.trdpty_tran_code is '第三方交易码';
comment on column ${iml_schema}.evt_bus_vouch_rgst_b.proc_step_cd is '处理步骤代码';
comment on column ${iml_schema}.evt_bus_vouch_rgst_b.proc_status_cd is '处理状态代码';
comment on column ${iml_schema}.evt_bus_vouch_rgst_b.proc_cnt is '处理次数';
comment on column ${iml_schema}.evt_bus_vouch_rgst_b.proc_dt is '处理日期';
comment on column ${iml_schema}.evt_bus_vouch_rgst_b.app_process_cd is '应用处理码';
comment on column ${iml_schema}.evt_bus_vouch_rgst_b.app_proc_info is '应用处理信息';
comment on column ${iml_schema}.evt_bus_vouch_rgst_b.blip_batch_no is '影像批次号';
comment on column ${iml_schema}.evt_bus_vouch_rgst_b.file_num_create_way_cd is '归档号生成方式代码';
comment on column ${iml_schema}.evt_bus_vouch_rgst_b.doc_upload_status_cd is '文件上传状态代码';
comment on column ${iml_schema}.evt_bus_vouch_rgst_b.org_id is '机构编号';
comment on column ${iml_schema}.evt_bus_vouch_rgst_b.teller_id is '柜员编号';
comment on column ${iml_schema}.evt_bus_vouch_rgst_b.init_create_dt is '最初创建日期';
comment on column ${iml_schema}.evt_bus_vouch_rgst_b.modif_dt is '修改日期';
comment on column ${iml_schema}.evt_bus_vouch_rgst_b.remark is '备注';
comment on column ${iml_schema}.evt_bus_vouch_rgst_b.remark_2 is '备注2';
comment on column ${iml_schema}.evt_bus_vouch_rgst_b.etl_dt is 'ETL处理日期';
comment on column ${iml_schema}.evt_bus_vouch_rgst_b.src_table_name is '源表名称';
comment on column ${iml_schema}.evt_bus_vouch_rgst_b.job_cd is '任务编码';
comment on column ${iml_schema}.evt_bus_vouch_rgst_b.etl_timestamp is 'ETL处理时间戳';
