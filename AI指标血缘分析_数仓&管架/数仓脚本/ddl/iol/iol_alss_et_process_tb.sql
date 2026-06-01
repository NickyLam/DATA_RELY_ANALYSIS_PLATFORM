/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol alss_et_process_tb
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.alss_et_process_tb
whenever sqlerror continue none;
drop table ${iol_schema}.alss_et_process_tb purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.alss_et_process_tb(
    form_id varchar2(57) -- 处理单编号
    ,form_type varchar2(6) -- 处理单类型
    ,node_no varchar2(96) -- 处理流程节点号
    ,create_time varchar2(90) -- 生成时间
    ,pre_node_no varchar2(15) -- 上一流程号
    ,deal_organ_no varchar2(96) -- 交易机构
    ,deal_organ_name varchar2(180) -- 机构名称
    ,deal_user_no varchar2(60) -- 处理人编号
    ,deal_user_name varchar2(180) -- 处理人名称
    ,deal_date varchar2(60) -- 处理日期
    ,deal_description varchar2(4000) -- 处理意见
    ,deal_result_text varchar2(300) -- 处理结果
    ,label_process varchar2(150) -- 处理流程标签
    ,process_show_level varchar2(30) -- 处理信息查看级别
    ,save_flag varchar2(15) -- 存储类型
    ,deal_result_node varchar2(96) -- 处理结果节点
    ,next_deal_no varchar2(96) -- 下次处理节点
    ,zc varchar2(60) -- 
    ,xc varchar2(90) -- 
    ,yn varchar2(15) -- 
    ,risk_busi_ct varchar2(150) -- 
    ,risk_busi_tx varchar2(150) -- 
    ,pre_lose varchar2(60) -- 
    ,real_lose varchar2(60) -- 
    ,lose_reason varchar2(150) -- 
    ,discipline_amount varchar2(30) -- 
    ,economic_amount varchar2(30) -- 
    ,punish_amount varchar2(60) -- 
    ,czy varchar2(60) -- 
    ,spy varchar2(60) -- 
    ,fx_flag varchar2(3) -- 
    ,file_name varchar2(900) -- 
    ,real_name varchar2(900) -- 
    ,file_path varchar2(900) -- 
    ,file_ext varchar2(900) -- 
    ,back_date varchar2(900) -- 应反馈日期
    ,over_flag varchar2(3) -- 分行是否逾期0否，1是
    ,next_deal_date varchar2(900) -- 
    ,next_deal_user varchar2(900) -- 
    ,deal_organ varchar2(900) -- 
    ,deal_organ_level varchar2(900) -- 
    ,over_days number -- 逾期天数
    ,risk_source_remak varchar2(2400) -- 
    ,risk_source_name varchar2(300) -- 
    ,risk_source_type varchar2(300) -- 
    ,risk_source_no varchar2(300) -- 
    ,operateremarks varchar2(900) -- 备注
    ,channelstatus varchar2(900) -- 处置状态
    ,operatestatus varchar2(900) -- 操作原因
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
grant select on ${iol_schema}.alss_et_process_tb to ${iml_schema};
grant select on ${iol_schema}.alss_et_process_tb to ${icl_schema};
grant select on ${iol_schema}.alss_et_process_tb to ${idl_schema};
grant select on ${iol_schema}.alss_et_process_tb to ${iel_schema};

-- comment
comment on table ${iol_schema}.alss_et_process_tb is '差错流程信息表';
comment on column ${iol_schema}.alss_et_process_tb.form_id is '处理单编号';
comment on column ${iol_schema}.alss_et_process_tb.form_type is '处理单类型';
comment on column ${iol_schema}.alss_et_process_tb.node_no is '处理流程节点号';
comment on column ${iol_schema}.alss_et_process_tb.create_time is '生成时间';
comment on column ${iol_schema}.alss_et_process_tb.pre_node_no is '上一流程号';
comment on column ${iol_schema}.alss_et_process_tb.deal_organ_no is '交易机构';
comment on column ${iol_schema}.alss_et_process_tb.deal_organ_name is '机构名称';
comment on column ${iol_schema}.alss_et_process_tb.deal_user_no is '处理人编号';
comment on column ${iol_schema}.alss_et_process_tb.deal_user_name is '处理人名称';
comment on column ${iol_schema}.alss_et_process_tb.deal_date is '处理日期';
comment on column ${iol_schema}.alss_et_process_tb.deal_description is '处理意见';
comment on column ${iol_schema}.alss_et_process_tb.deal_result_text is '处理结果';
comment on column ${iol_schema}.alss_et_process_tb.label_process is '处理流程标签';
comment on column ${iol_schema}.alss_et_process_tb.process_show_level is '处理信息查看级别';
comment on column ${iol_schema}.alss_et_process_tb.save_flag is '存储类型';
comment on column ${iol_schema}.alss_et_process_tb.deal_result_node is '处理结果节点';
comment on column ${iol_schema}.alss_et_process_tb.next_deal_no is '下次处理节点';
comment on column ${iol_schema}.alss_et_process_tb.zc is '';
comment on column ${iol_schema}.alss_et_process_tb.xc is '';
comment on column ${iol_schema}.alss_et_process_tb.yn is '';
comment on column ${iol_schema}.alss_et_process_tb.risk_busi_ct is '';
comment on column ${iol_schema}.alss_et_process_tb.risk_busi_tx is '';
comment on column ${iol_schema}.alss_et_process_tb.pre_lose is '';
comment on column ${iol_schema}.alss_et_process_tb.real_lose is '';
comment on column ${iol_schema}.alss_et_process_tb.lose_reason is '';
comment on column ${iol_schema}.alss_et_process_tb.discipline_amount is '';
comment on column ${iol_schema}.alss_et_process_tb.economic_amount is '';
comment on column ${iol_schema}.alss_et_process_tb.punish_amount is '';
comment on column ${iol_schema}.alss_et_process_tb.czy is '';
comment on column ${iol_schema}.alss_et_process_tb.spy is '';
comment on column ${iol_schema}.alss_et_process_tb.fx_flag is '';
comment on column ${iol_schema}.alss_et_process_tb.file_name is '';
comment on column ${iol_schema}.alss_et_process_tb.real_name is '';
comment on column ${iol_schema}.alss_et_process_tb.file_path is '';
comment on column ${iol_schema}.alss_et_process_tb.file_ext is '';
comment on column ${iol_schema}.alss_et_process_tb.back_date is '应反馈日期';
comment on column ${iol_schema}.alss_et_process_tb.over_flag is '分行是否逾期0否，1是';
comment on column ${iol_schema}.alss_et_process_tb.next_deal_date is '';
comment on column ${iol_schema}.alss_et_process_tb.next_deal_user is '';
comment on column ${iol_schema}.alss_et_process_tb.deal_organ is '';
comment on column ${iol_schema}.alss_et_process_tb.deal_organ_level is '';
comment on column ${iol_schema}.alss_et_process_tb.over_days is '逾期天数';
comment on column ${iol_schema}.alss_et_process_tb.risk_source_remak is '';
comment on column ${iol_schema}.alss_et_process_tb.risk_source_name is '';
comment on column ${iol_schema}.alss_et_process_tb.risk_source_type is '';
comment on column ${iol_schema}.alss_et_process_tb.risk_source_no is '';
comment on column ${iol_schema}.alss_et_process_tb.operateremarks is '备注';
comment on column ${iol_schema}.alss_et_process_tb.channelstatus is '处置状态';
comment on column ${iol_schema}.alss_et_process_tb.operatestatus is '操作原因';
comment on column ${iol_schema}.alss_et_process_tb.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.alss_et_process_tb.etl_timestamp is 'ETL处理时间戳';
