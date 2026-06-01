/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol bdms_sdn_dpst_apply
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.bdms_sdn_dpst_apply
whenever sqlerror continue none;
drop table ${iol_schema}.bdms_sdn_dpst_apply purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.bdms_sdn_dpst_apply(
    id varchar2(60) -- ID
    ,analysis_id varchar2(60) -- 解析表ID
    ,apply_date varchar2(12) -- 存托申请日期
    ,req_brh_id varchar2(14) -- 存托申请方机构代码
    ,sum_draft_amount number(18,2) -- 存托票据汇总金额
    ,sum_settle_amount number(18,2) -- 存托结算汇总金额
    ,fin_rate_up number(9,6) -- 存托利率上限
    ,fin_rate_down number(9,6) -- 存托利率下限
    ,rate number(9,6) -- 融资利率
    ,apply_id varchar2(30) -- 存托申请单编号
    ,dpst_no varchar2(30) -- 存托单编号
    ,dpst_result varchar2(2) -- 产品创设结果： 0 创设中 1 创设成功 2 创设失败
    ,dpst_status varchar2(8) -- 申请单状态： DAP01 申请单已发送 DAP02 申请单待清算 DAP03 申请单清算中 DAP04 申请单清算成功 DAP05 申请单清算失败 DAP06 申请单已终止 DAP07 申请单已作废 DAP08 申请单异常 DAP09 申请单待复核 DAP10 申请单已拒绝
    ,settle_date varchar2(12) -- 结算日期
    ,settle_mode varchar2(6) -- 结算方式： ST01 票款对付(DVP) ST02 纯票过户(FOP)
    ,proc_code varchar2(14) -- 返回码
    ,proc_msg varchar2(1152) -- 返回结果
    ,rs_product varchar2(14) -- 存托应答方存托类产品
    ,rs_product_name varchar2(384) -- 存托产品名称
    ,last_upd_opr varchar2(45) -- 最后操作员
    ,last_upd_time varchar2(21) -- 最后修改时间
    ,reserve1 varchar2(384) -- 备用字段1
    ,reserve2 varchar2(384) -- 备用字段2
    ,settle_status varchar2(5) -- 结算状态： R20 结算成功 R21 结算失败
    ,settle_fail_code varchar2(6) -- 结算失败代码： SF00 买方未确认 SF01 卖方未确认 SF02 双方未确认 SF03 资金结算失败 SF04 票据结算失败
    ,create_time varchar2(21) -- 创建时间
    ,create_by varchar2(45) -- 创建人
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
grant select on ${iol_schema}.bdms_sdn_dpst_apply to ${iml_schema};
grant select on ${iol_schema}.bdms_sdn_dpst_apply to ${icl_schema};
grant select on ${iol_schema}.bdms_sdn_dpst_apply to ${idl_schema};
grant select on ${iol_schema}.bdms_sdn_dpst_apply to ${iel_schema};

-- comment
comment on table ${iol_schema}.bdms_sdn_dpst_apply is '存托申请单表';
comment on column ${iol_schema}.bdms_sdn_dpst_apply.id is 'ID';
comment on column ${iol_schema}.bdms_sdn_dpst_apply.analysis_id is '解析表ID';
comment on column ${iol_schema}.bdms_sdn_dpst_apply.apply_date is '存托申请日期';
comment on column ${iol_schema}.bdms_sdn_dpst_apply.req_brh_id is '存托申请方机构代码';
comment on column ${iol_schema}.bdms_sdn_dpst_apply.sum_draft_amount is '存托票据汇总金额';
comment on column ${iol_schema}.bdms_sdn_dpst_apply.sum_settle_amount is '存托结算汇总金额';
comment on column ${iol_schema}.bdms_sdn_dpst_apply.fin_rate_up is '存托利率上限';
comment on column ${iol_schema}.bdms_sdn_dpst_apply.fin_rate_down is '存托利率下限';
comment on column ${iol_schema}.bdms_sdn_dpst_apply.rate is '融资利率';
comment on column ${iol_schema}.bdms_sdn_dpst_apply.apply_id is '存托申请单编号';
comment on column ${iol_schema}.bdms_sdn_dpst_apply.dpst_no is '存托单编号';
comment on column ${iol_schema}.bdms_sdn_dpst_apply.dpst_result is '产品创设结果： 0 创设中 1 创设成功 2 创设失败';
comment on column ${iol_schema}.bdms_sdn_dpst_apply.dpst_status is '申请单状态： DAP01 申请单已发送 DAP02 申请单待清算 DAP03 申请单清算中 DAP04 申请单清算成功 DAP05 申请单清算失败 DAP06 申请单已终止 DAP07 申请单已作废 DAP08 申请单异常 DAP09 申请单待复核 DAP10 申请单已拒绝';
comment on column ${iol_schema}.bdms_sdn_dpst_apply.settle_date is '结算日期';
comment on column ${iol_schema}.bdms_sdn_dpst_apply.settle_mode is '结算方式： ST01 票款对付(DVP) ST02 纯票过户(FOP)';
comment on column ${iol_schema}.bdms_sdn_dpst_apply.proc_code is '返回码';
comment on column ${iol_schema}.bdms_sdn_dpst_apply.proc_msg is '返回结果';
comment on column ${iol_schema}.bdms_sdn_dpst_apply.rs_product is '存托应答方存托类产品';
comment on column ${iol_schema}.bdms_sdn_dpst_apply.rs_product_name is '存托产品名称';
comment on column ${iol_schema}.bdms_sdn_dpst_apply.last_upd_opr is '最后操作员';
comment on column ${iol_schema}.bdms_sdn_dpst_apply.last_upd_time is '最后修改时间';
comment on column ${iol_schema}.bdms_sdn_dpst_apply.reserve1 is '备用字段1';
comment on column ${iol_schema}.bdms_sdn_dpst_apply.reserve2 is '备用字段2';
comment on column ${iol_schema}.bdms_sdn_dpst_apply.settle_status is '结算状态： R20 结算成功 R21 结算失败';
comment on column ${iol_schema}.bdms_sdn_dpst_apply.settle_fail_code is '结算失败代码： SF00 买方未确认 SF01 卖方未确认 SF02 双方未确认 SF03 资金结算失败 SF04 票据结算失败';
comment on column ${iol_schema}.bdms_sdn_dpst_apply.create_time is '创建时间';
comment on column ${iol_schema}.bdms_sdn_dpst_apply.create_by is '创建人';
comment on column ${iol_schema}.bdms_sdn_dpst_apply.start_dt is '开始时间';
comment on column ${iol_schema}.bdms_sdn_dpst_apply.end_dt is '结束时间';
comment on column ${iol_schema}.bdms_sdn_dpst_apply.id_mark is '增删标志';
comment on column ${iol_schema}.bdms_sdn_dpst_apply.etl_timestamp is 'ETL处理时间戳';
