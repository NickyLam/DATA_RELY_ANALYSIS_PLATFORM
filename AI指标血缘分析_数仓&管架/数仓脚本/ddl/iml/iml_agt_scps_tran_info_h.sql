/*
Purpose:    整合模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iml agt_scps_tran_info_h
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iml_schema}.agt_scps_tran_info_h
whenever sqlerror continue none;
drop table ${iml_schema}.agt_scps_tran_info_h purge;

whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.agt_scps_tran_info_h(
    agt_id varchar2(250) -- 协议编号
    ,lp_id varchar2(100) -- 法人编号
    ,task_no varchar2(100) -- 任务号
    ,bank_no varchar2(60) -- 银行行号
    ,sys_id varchar2(100) -- 系统编号
    ,sub_task_no varchar2(100) -- 子任务号
    ,init_task_no varchar2(100) -- 原任务号
    ,task_status_cd varchar2(30) -- 任务状态代码
    ,payment_flow_num varchar2(100) -- 前台流水号
    ,ova_flow_num varchar2(100) -- 全局流水号
    ,tran_code varchar2(30) -- 交易码
    ,bus_scene_id varchar2(100) -- 业务场景编号
    ,tran_dt date -- 交易日期
    ,tran_tm timestamp -- 交易时间
    ,chn_id varchar2(100) -- 渠道编号
    ,blip_flow_num varchar2(100) -- 影像流水号
    ,ghb_acct_id varchar2(100) -- 本行账户编号
    ,ghb_acct_name varchar2(500) -- 本行账户名称
    ,invalid_tm timestamp -- 失效时间
    ,invalid_dt date -- 失效日期
    ,refuse_rs_descb varchar2(2000) -- 拒绝原因描述
    ,err_idtfy_rs_descb varchar2(4000) -- 差错认定原因描述
    ,opera_mode_cd varchar2(30) -- 作业模式代码
    ,opera_status_cd varchar2(30) -- 作业状态代码
    ,remark varchar2(500) -- 备注
    ,bus_init_teller_id varchar2(100) -- 业务发起柜员编号
    ,bus_init_director_teller_id varchar2(100) -- 业务发起主管柜员编号
    ,bus_init_org_id varchar2(100) -- 业务发起机构编号
    ,oper_status_cd varchar2(30) -- 操作状态代码
    ,bus_gen_cd varchar2(30) -- 业务大类代码
    ,prob_node_cd varchar2(30) -- 问题节点代码
    ,prob_cls_cd varchar2(30) -- 问题分类代码
    ,prob_init_dt date -- 问题发起日期
    ,prob_init_tm timestamp -- 问题发起时间
    ,prob_rs varchar2(500) -- 问题原因     --增加字段长度
    ,prob_init_teller_id varchar2(100) -- 问题发起柜员编号
    ,issue_dt date -- 发布日期
    ,issue_tm timestamp -- 发布时间
    ,check_idtfy_rest_cd varchar2(30) -- 审核认定结果代码
    ,check_remark varchar2(4000) -- 审核备注
    ,check_idtfy_rs varchar2(4000) -- 审核认定原因
    ,authoriz_diret_teller_id varchar2(100) -- 授权主管柜员编号
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
grant select on ${iml_schema}.agt_scps_tran_info_h to ${icl_schema};
grant select on ${iml_schema}.agt_scps_tran_info_h to ${idl_schema};
grant select on ${iml_schema}.agt_scps_tran_info_h to ${iel_schema};

-- comment
comment on table ${iml_schema}.agt_scps_tran_info_h is '后援中心退拒件信息历史';
comment on column ${iml_schema}.agt_scps_tran_info_h.agt_id is '协议编号';
comment on column ${iml_schema}.agt_scps_tran_info_h.lp_id is '法人编号';
comment on column ${iml_schema}.agt_scps_tran_info_h.task_no is '任务号';
comment on column ${iml_schema}.agt_scps_tran_info_h.bank_no is '银行行号';
comment on column ${iml_schema}.agt_scps_tran_info_h.sys_id is '系统编号';
comment on column ${iml_schema}.agt_scps_tran_info_h.sub_task_no is '子任务号';
comment on column ${iml_schema}.agt_scps_tran_info_h.init_task_no is '原任务号';
comment on column ${iml_schema}.agt_scps_tran_info_h.task_status_cd is '任务状态代码';
comment on column ${iml_schema}.agt_scps_tran_info_h.payment_flow_num is '前台流水号';
comment on column ${iml_schema}.agt_scps_tran_info_h.ova_flow_num is '全局流水号';
comment on column ${iml_schema}.agt_scps_tran_info_h.tran_code is '交易码';
comment on column ${iml_schema}.agt_scps_tran_info_h.bus_scene_id is '业务场景编号';
comment on column ${iml_schema}.agt_scps_tran_info_h.tran_dt is '交易日期';
comment on column ${iml_schema}.agt_scps_tran_info_h.tran_tm is '交易时间';
comment on column ${iml_schema}.agt_scps_tran_info_h.chn_id is '渠道编号';
comment on column ${iml_schema}.agt_scps_tran_info_h.blip_flow_num is '影像流水号';
comment on column ${iml_schema}.agt_scps_tran_info_h.ghb_acct_id is '本行账户编号';
comment on column ${iml_schema}.agt_scps_tran_info_h.ghb_acct_name is '本行账户名称';
comment on column ${iml_schema}.agt_scps_tran_info_h.invalid_tm is '失效时间';
comment on column ${iml_schema}.agt_scps_tran_info_h.invalid_dt is '失效日期';
comment on column ${iml_schema}.agt_scps_tran_info_h.refuse_rs_descb is '拒绝原因描述';
comment on column ${iml_schema}.agt_scps_tran_info_h.err_idtfy_rs_descb is '差错认定原因描述';
comment on column ${iml_schema}.agt_scps_tran_info_h.opera_mode_cd is '作业模式代码';
comment on column ${iml_schema}.agt_scps_tran_info_h.opera_status_cd is '作业状态代码';
comment on column ${iml_schema}.agt_scps_tran_info_h.remark is '备注';
comment on column ${iml_schema}.agt_scps_tran_info_h.bus_init_teller_id is '业务发起柜员编号';
comment on column ${iml_schema}.agt_scps_tran_info_h.bus_init_director_teller_id is '业务发起主管柜员编号';
comment on column ${iml_schema}.agt_scps_tran_info_h.bus_init_org_id is '业务发起机构编号';
comment on column ${iml_schema}.agt_scps_tran_info_h.oper_status_cd is '操作状态代码';
comment on column ${iml_schema}.agt_scps_tran_info_h.bus_gen_cd is '业务大类代码';
comment on column ${iml_schema}.agt_scps_tran_info_h.prob_node_cd is '问题节点代码';
comment on column ${iml_schema}.agt_scps_tran_info_h.prob_cls_cd is '问题分类代码';
comment on column ${iml_schema}.agt_scps_tran_info_h.prob_init_dt is '问题发起日期';
comment on column ${iml_schema}.agt_scps_tran_info_h.prob_init_tm is '问题发起时间';
comment on column ${iml_schema}.agt_scps_tran_info_h.prob_rs is '问题原因';
comment on column ${iml_schema}.agt_scps_tran_info_h.prob_init_teller_id is '问题发起柜员编号';
comment on column ${iml_schema}.agt_scps_tran_info_h.issue_dt is '发布日期';
comment on column ${iml_schema}.agt_scps_tran_info_h.issue_tm is '发布时间';
comment on column ${iml_schema}.agt_scps_tran_info_h.check_idtfy_rest_cd is '审核认定结果代码';
comment on column ${iml_schema}.agt_scps_tran_info_h.check_remark is '审核备注';
comment on column ${iml_schema}.agt_scps_tran_info_h.check_idtfy_rs is '审核认定原因';
comment on column ${iml_schema}.agt_scps_tran_info_h.authoriz_diret_teller_id is '授权主管柜员编号';
comment on column ${iml_schema}.agt_scps_tran_info_h.start_dt is '开始时间';
comment on column ${iml_schema}.agt_scps_tran_info_h.end_dt is '结束时间';
comment on column ${iml_schema}.agt_scps_tran_info_h.id_mark is '增删标志';
comment on column ${iml_schema}.agt_scps_tran_info_h.src_table_name is '源表名称';
comment on column ${iml_schema}.agt_scps_tran_info_h.job_cd is '任务编码';
comment on column ${iml_schema}.agt_scps_tran_info_h.etl_timestamp is 'ETL处理时间戳';
