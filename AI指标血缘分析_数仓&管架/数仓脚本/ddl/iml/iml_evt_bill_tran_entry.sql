/*
Purpose:    整合模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iml evt_bill_tran_entry
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iml_schema}.evt_bill_tran_entry
whenever sqlerror continue none;
drop table ${iml_schema}.evt_bill_tran_entry purge;

whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.evt_bill_tran_entry(
    evt_id varchar2(250) -- 事件编号
    ,lp_id varchar2(100) -- 法人编号
    ,rgst_id varchar2(100) -- 登记编号
    ,indent_id varchar2(250) -- 订单编号
    ,tran_req_id varchar2(250) -- 交易请求编号
    ,tran_flow_num varchar2(250) -- 交易流水号
    ,tran_dt date -- 交易日期
    ,tran_org_id varchar2(100) -- 交易机构编号
    ,tran_attr_string varchar2(500) -- 交易属性字符串
    ,belong_hq_org_id varchar2(100) -- 所属总行机构编号
    ,entry_tran_id varchar2(100) -- 记账交易编号
    ,entry_dt date -- 记账日期
    ,core_entry_flow_num varchar2(250) -- 核心记账流水号
    ,entry_flg varchar2(10) -- 记账标志
    ,entry_status_cd varchar2(10) -- 记账状态代码
    ,entry_ext_attr varchar2(1000) -- 记账扩展属性
    ,final_entry_dt date -- 最后记账日期
    ,prod_id varchar2(100) -- 产品编号
    ,batch_id varchar2(100) -- 业务批次编号
    ,bus_agt_id varchar2(100) -- 业务协议编号
    ,bus_dtl_id varchar2(250) -- 业务明细编号
    ,bill_id varchar2(100) -- 票据编号
    ,bill_num varchar2(100) -- 票据号码
    ,bill_amt number(30,2) -- 票据金额
    ,bill_src_cd varchar2(30) -- 票据来源代码
    ,sys_id varchar2(100) -- 系统编号
    ,init_bill_id varchar2(250) -- 原票据编号
    ,bill_sub_intrv_id varchar2(100) -- 票据子区间编号
    ,allow_pkg_ccution_flg varchar2(30) -- 允许分包流转标志
    ,old_init_bill_id varchar2(100) -- 原始票据编号
    ,splt_bf_bill_id varchar2(100) -- 拆分前票据编号
    ,ext_amt_1 number(30,2) -- 扩展金额一
    ,ext_amt_2 number(30,2) -- 扩展金额二
    ,ext_amt_3 number(30,2) -- 扩展金额三
    ,prtcptr_ext varchar2(500) -- 参与方扩展
    ,intfc_return_code varchar2(90) -- 接口返回码
    ,intfc_return_type_cd varchar2(60) -- 接口返回类型代码
    ,intfc_return_descb varchar2(1000) -- 接口返回描述
    ,remark_1 varchar2(500) -- 备注一
    ,remark_2 varchar2(500) -- 备注二
    ,remark_3 varchar2(500) -- 备注三
    ,remark_4 varchar2(500) -- 备注四
    ,fin_org_id varchar2(100) -- 财务机构编号
    ,fir_create_dt date -- 最初创建日期
    ,final_update_tm date -- 最后更新日期
    ,final_operr_id varchar2(100) -- 最后操作员编号
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
grant select on ${iml_schema}.evt_bill_tran_entry to ${icl_schema};
grant select on ${iml_schema}.evt_bill_tran_entry to ${idl_schema};
grant select on ${iml_schema}.evt_bill_tran_entry to ${iel_schema};

-- comment
comment on table ${iml_schema}.evt_bill_tran_entry is '票据记账交易事件';
comment on column ${iml_schema}.evt_bill_tran_entry.evt_id is '事件编号';
comment on column ${iml_schema}.evt_bill_tran_entry.lp_id is '法人编号';
comment on column ${iml_schema}.evt_bill_tran_entry.rgst_id is '登记编号';
comment on column ${iml_schema}.evt_bill_tran_entry.indent_id is '订单编号';
comment on column ${iml_schema}.evt_bill_tran_entry.tran_req_id is '交易请求编号';
comment on column ${iml_schema}.evt_bill_tran_entry.tran_flow_num is '交易流水号';
comment on column ${iml_schema}.evt_bill_tran_entry.tran_dt is '交易日期';
comment on column ${iml_schema}.evt_bill_tran_entry.tran_org_id is '交易机构编号';
comment on column ${iml_schema}.evt_bill_tran_entry.tran_attr_string is '交易属性字符串';
comment on column ${iml_schema}.evt_bill_tran_entry.belong_hq_org_id is '所属总行机构编号';
comment on column ${iml_schema}.evt_bill_tran_entry.entry_tran_id is '记账交易编号';
comment on column ${iml_schema}.evt_bill_tran_entry.entry_dt is '记账日期';
comment on column ${iml_schema}.evt_bill_tran_entry.core_entry_flow_num is '核心记账流水号';
comment on column ${iml_schema}.evt_bill_tran_entry.entry_flg is '记账标志';
comment on column ${iml_schema}.evt_bill_tran_entry.entry_status_cd is '记账状态代码';
comment on column ${iml_schema}.evt_bill_tran_entry.entry_ext_attr is '记账扩展属性';
comment on column ${iml_schema}.evt_bill_tran_entry.final_entry_dt is '最后记账日期';
comment on column ${iml_schema}.evt_bill_tran_entry.prod_id is '产品编号';
comment on column ${iml_schema}.evt_bill_tran_entry.batch_id is '业务批次编号';
comment on column ${iml_schema}.evt_bill_tran_entry.bus_agt_id is '业务协议编号';
comment on column ${iml_schema}.evt_bill_tran_entry.bus_dtl_id is '业务明细编号';
comment on column ${iml_schema}.evt_bill_tran_entry.bill_id is '票据编号';
comment on column ${iml_schema}.evt_bill_tran_entry.bill_num is '票据号码';
comment on column ${iml_schema}.evt_bill_tran_entry.bill_amt is '票据金额';
comment on column ${iml_schema}.evt_bill_tran_entry.bill_src_cd is '票据来源代码';
comment on column ${iml_schema}.evt_bill_tran_entry.sys_id is '系统编号';
comment on column ${iml_schema}.evt_bill_tran_entry.init_bill_id is '原票据编号';
comment on column ${iml_schema}.evt_bill_tran_entry.bill_sub_intrv_id is '票据子区间编号';
comment on column ${iml_schema}.evt_bill_tran_entry.allow_pkg_ccution_flg is '允许分包流转标志';
comment on column ${iml_schema}.evt_bill_tran_entry.old_init_bill_id is '原始票据编号';
comment on column ${iml_schema}.evt_bill_tran_entry.splt_bf_bill_id is '拆分前票据编号';
comment on column ${iml_schema}.evt_bill_tran_entry.ext_amt_1 is '扩展金额一';
comment on column ${iml_schema}.evt_bill_tran_entry.ext_amt_2 is '扩展金额二';
comment on column ${iml_schema}.evt_bill_tran_entry.ext_amt_3 is '扩展金额三';
comment on column ${iml_schema}.evt_bill_tran_entry.prtcptr_ext is '参与方扩展';
comment on column ${iml_schema}.evt_bill_tran_entry.intfc_return_code is '接口返回码';
comment on column ${iml_schema}.evt_bill_tran_entry.intfc_return_type_cd is '接口返回类型代码';
comment on column ${iml_schema}.evt_bill_tran_entry.intfc_return_descb is '接口返回描述';
comment on column ${iml_schema}.evt_bill_tran_entry.remark_1 is '备注一';
comment on column ${iml_schema}.evt_bill_tran_entry.remark_2 is '备注二';
comment on column ${iml_schema}.evt_bill_tran_entry.remark_3 is '备注三';
comment on column ${iml_schema}.evt_bill_tran_entry.remark_4 is '备注四';
comment on column ${iml_schema}.evt_bill_tran_entry.fin_org_id is '财务机构编号';
comment on column ${iml_schema}.evt_bill_tran_entry.fir_create_dt is '最初创建日期';
comment on column ${iml_schema}.evt_bill_tran_entry.final_update_tm is '最后更新日期';
comment on column ${iml_schema}.evt_bill_tran_entry.final_operr_id is '最后操作员编号';
comment on column ${iml_schema}.evt_bill_tran_entry.etl_dt is 'ETL处理日期';
comment on column ${iml_schema}.evt_bill_tran_entry.src_table_name is '源表名称';
comment on column ${iml_schema}.evt_bill_tran_entry.job_cd is '任务编码';
comment on column ${iml_schema}.evt_bill_tran_entry.etl_timestamp is 'ETL处理时间戳';
