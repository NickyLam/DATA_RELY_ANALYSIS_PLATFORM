/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol bdms_cpes_dpst_details
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.bdms_cpes_dpst_details
whenever sqlerror continue none;
drop table ${iol_schema}.bdms_cpes_dpst_details purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.bdms_cpes_dpst_details(
    id varchar2(60) -- ID
    ,contract_id varchar2(60) -- 批次表ID
    ,apply_id varchar2(30) -- 存托申请单编号
    ,rs_product varchar2(14) -- 存托应答方存托类产品
    ,req_date varchar2(12) -- 存托申请日期
    ,fin_rate_up number(9,6) -- 融资利率上限
    ,fin_rate_down number(9,6) -- 融资利率下限
    ,settle_mode varchar2(6) -- 结算方式： ST01 票款对付(DVP) ST02 纯票过户(FOP)
    ,req_social_code varchar2(27) -- 存托申请人社会统一信用代码
    ,req_platform_code varchar2(9) -- 存托申请人所在平台代码
    ,req_bank_no varchar2(18) -- 存托申请人开户行行号
    ,req_acct_no varchar2(48) -- 存托申请人开户行账号
    ,req_org_code varchar2(15) -- 存托机构代码
    ,std_product_code varchar2(14) -- 标准化票据产品代码
    ,std_product_bank_no varchar2(18) -- 标准化票据产品开户行行号
    ,std_product_bank_name varchar2(270) -- 标准化票据产品开户行名称
    ,dpst_deal_id varchar2(30) -- 存托单编号：结算结果通知的存托单编号
    ,fin_rate number(9,6) -- 融资利率
    ,pay_interest number(18,2) -- 应付利息
    ,adjust_pay_interest number(18,2) -- 调整后应付利息
    ,draft_amt number(18,2) -- 票据金额
    ,settle_amt number(18,2) -- 结算金额
    ,settle_date varchar2(12) -- 结算日期
    ,settle_status varchar2(5) -- 结算状态： R20 结算成功 R21 结算失败
    ,settle_fail_code varchar2(6) -- 结算失败代码： SF00 买方未确认 SF01 卖方未确认 SF02 双方未确认 SF03 资金结算失败 SF04 票据结算失败
    ,dpst_status varchar2(8) -- 申请单状态： DAP01 申请单已发送 DAP02 申请单待清算 DAP03 申请单清算中 DAP04 申请单清算成功 DAP05 申请单清算失败 DAP06 申请单已终止 DAP07 申请单已作废 DAP08 申请单异常 DAP09 申请单待复核 DAP10 申请单已拒绝
    ,account_status varchar2(3) -- 记账状态： 00 未处理 01 记账中 02 记账成功 03 记账失败 04 抹账成功 05 抹账失败
    ,last_upd_opr varchar2(45) -- 最后操作员
    ,last_upd_time varchar2(21) -- 最后修改时间
    ,reserve1 varchar2(384) -- 备用字段1
    ,reserve2 varchar2(384) -- 备用字段2
    ,aoa_acct_name_acctname varchar2(675) -- 资金账户名称
    ,req_name varchar2(675) -- 申请人名称
    ,asset_type varchar2(6) -- 资产类型 DBT01 未贴现票据 DBT02 已贴现票据
    ,req_brh_no varchar2(14) -- 存托申请人机构号
    ,aoa_acct varchar2(48) -- 资金账户
    ,aoa_brh_no varchar2(14) -- 资金账户开户行机构参与者代码
    ,req_acct_name varchar2(675) -- 存托申请人账户名称
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
grant select on ${iol_schema}.bdms_cpes_dpst_details to ${iml_schema};
grant select on ${iol_schema}.bdms_cpes_dpst_details to ${icl_schema};
grant select on ${iol_schema}.bdms_cpes_dpst_details to ${idl_schema};
grant select on ${iol_schema}.bdms_cpes_dpst_details to ${iel_schema};

-- comment
comment on table ${iol_schema}.bdms_cpes_dpst_details is '存托申请单业务明细表';
comment on column ${iol_schema}.bdms_cpes_dpst_details.id is 'ID';
comment on column ${iol_schema}.bdms_cpes_dpst_details.contract_id is '批次表ID';
comment on column ${iol_schema}.bdms_cpes_dpst_details.apply_id is '存托申请单编号';
comment on column ${iol_schema}.bdms_cpes_dpst_details.rs_product is '存托应答方存托类产品';
comment on column ${iol_schema}.bdms_cpes_dpst_details.req_date is '存托申请日期';
comment on column ${iol_schema}.bdms_cpes_dpst_details.fin_rate_up is '融资利率上限';
comment on column ${iol_schema}.bdms_cpes_dpst_details.fin_rate_down is '融资利率下限';
comment on column ${iol_schema}.bdms_cpes_dpst_details.settle_mode is '结算方式： ST01 票款对付(DVP) ST02 纯票过户(FOP)';
comment on column ${iol_schema}.bdms_cpes_dpst_details.req_social_code is '存托申请人社会统一信用代码';
comment on column ${iol_schema}.bdms_cpes_dpst_details.req_platform_code is '存托申请人所在平台代码';
comment on column ${iol_schema}.bdms_cpes_dpst_details.req_bank_no is '存托申请人开户行行号';
comment on column ${iol_schema}.bdms_cpes_dpst_details.req_acct_no is '存托申请人开户行账号';
comment on column ${iol_schema}.bdms_cpes_dpst_details.req_org_code is '存托机构代码';
comment on column ${iol_schema}.bdms_cpes_dpst_details.std_product_code is '标准化票据产品代码';
comment on column ${iol_schema}.bdms_cpes_dpst_details.std_product_bank_no is '标准化票据产品开户行行号';
comment on column ${iol_schema}.bdms_cpes_dpst_details.std_product_bank_name is '标准化票据产品开户行名称';
comment on column ${iol_schema}.bdms_cpes_dpst_details.dpst_deal_id is '存托单编号：结算结果通知的存托单编号';
comment on column ${iol_schema}.bdms_cpes_dpst_details.fin_rate is '融资利率';
comment on column ${iol_schema}.bdms_cpes_dpst_details.pay_interest is '应付利息';
comment on column ${iol_schema}.bdms_cpes_dpst_details.adjust_pay_interest is '调整后应付利息';
comment on column ${iol_schema}.bdms_cpes_dpst_details.draft_amt is '票据金额';
comment on column ${iol_schema}.bdms_cpes_dpst_details.settle_amt is '结算金额';
comment on column ${iol_schema}.bdms_cpes_dpst_details.settle_date is '结算日期';
comment on column ${iol_schema}.bdms_cpes_dpst_details.settle_status is '结算状态： R20 结算成功 R21 结算失败';
comment on column ${iol_schema}.bdms_cpes_dpst_details.settle_fail_code is '结算失败代码： SF00 买方未确认 SF01 卖方未确认 SF02 双方未确认 SF03 资金结算失败 SF04 票据结算失败';
comment on column ${iol_schema}.bdms_cpes_dpst_details.dpst_status is '申请单状态： DAP01 申请单已发送 DAP02 申请单待清算 DAP03 申请单清算中 DAP04 申请单清算成功 DAP05 申请单清算失败 DAP06 申请单已终止 DAP07 申请单已作废 DAP08 申请单异常 DAP09 申请单待复核 DAP10 申请单已拒绝';
comment on column ${iol_schema}.bdms_cpes_dpst_details.account_status is '记账状态： 00 未处理 01 记账中 02 记账成功 03 记账失败 04 抹账成功 05 抹账失败';
comment on column ${iol_schema}.bdms_cpes_dpst_details.last_upd_opr is '最后操作员';
comment on column ${iol_schema}.bdms_cpes_dpst_details.last_upd_time is '最后修改时间';
comment on column ${iol_schema}.bdms_cpes_dpst_details.reserve1 is '备用字段1';
comment on column ${iol_schema}.bdms_cpes_dpst_details.reserve2 is '备用字段2';
comment on column ${iol_schema}.bdms_cpes_dpst_details.aoa_acct_name_acctname is '资金账户名称';
comment on column ${iol_schema}.bdms_cpes_dpst_details.req_name is '申请人名称';
comment on column ${iol_schema}.bdms_cpes_dpst_details.asset_type is '资产类型 DBT01 未贴现票据 DBT02 已贴现票据';
comment on column ${iol_schema}.bdms_cpes_dpst_details.req_brh_no is '存托申请人机构号';
comment on column ${iol_schema}.bdms_cpes_dpst_details.aoa_acct is '资金账户';
comment on column ${iol_schema}.bdms_cpes_dpst_details.aoa_brh_no is '资金账户开户行机构参与者代码';
comment on column ${iol_schema}.bdms_cpes_dpst_details.req_acct_name is '存托申请人账户名称';
comment on column ${iol_schema}.bdms_cpes_dpst_details.start_dt is '开始时间';
comment on column ${iol_schema}.bdms_cpes_dpst_details.end_dt is '结束时间';
comment on column ${iol_schema}.bdms_cpes_dpst_details.id_mark is '增删标志';
comment on column ${iol_schema}.bdms_cpes_dpst_details.etl_timestamp is 'ETL处理时间戳';
