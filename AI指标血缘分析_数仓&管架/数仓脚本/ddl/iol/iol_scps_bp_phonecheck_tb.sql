/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol scps_bp_phonecheck_tb
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.scps_bp_phonecheck_tb
whenever sqlerror continue none;
drop table ${iol_schema}.scps_bp_phonecheck_tb purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.scps_bp_phonecheck_tb(
    task_id varchar2(128) -- 任务号
    ,bus_serial_number varchar2(66) -- 业务流水号
    ,cust_id varchar2(64) -- 客户号
    ,cust_name varchar2(400) -- 客户名称
    ,account varchar2(100) -- 收款账号
    ,payee_name varchar2(400) -- 收款账户名称
    ,payer_account varchar2(100) -- 付款账号
    ,payer_name varchar2(400) -- 付款人名称
    ,deal_code varchar2(64) -- 交易码
    ,scene_code varchar2(128) -- 场景号
    ,check_flag varchar2(4) -- 查证标识（00-免查证，01-待查证，02-查证中，03-查证通过，04-查证不通过，05-无法联系，06-查证异常，07-撤销查证）
    ,onesecreason varchar2(400) -- 二级原因
    ,onecheckresult varchar2(400) -- 查证答案
    ,deal_time date -- 交易日期
    ,check_expire_date varchar2(40) -- 查证到期日
    ,check_company varchar2(400) -- 查证公司
    ,amount varchar2(40) -- 交易金额
    ,currency varchar2(64) -- 币种
    ,use varchar2(600) -- 用途
    ,channel varchar2(64) -- 渠道编号
    ,vouchgroup varchar2(64) -- 凭证组合
    ,doc_id varchar2(100) -- 影像批次号
    ,check_type varchar2(2) -- 查证类型(1-请求查证 2-撤销查证)
    ,ticket_issues_date varchar2(40) -- 票据签发日期
    ,trans_bu_ser_no varchar2(64) -- 办理柜员工号
    ,trans_bu_name varchar2(400) -- 办理柜员姓名
    ,trans_bu_phone varchar2(64) -- 办理柜员电话
    ,trans_bu_email varchar2(64) -- 办理柜员邮箱
    ,cust_mgr_no varchar2(64) -- 客户经理工号
    ,cust_mgr_name varchar2(400) -- 客户经理姓名
    ,cust_mgr_phone varchar2(64) -- 客户经理手机
    ,cust_mgr_email varchar2(64) -- 客户经理邮箱
    ,cust_mgr_organ varchar2(64) -- 客户经理所属机构
    ,give_money_date date -- 放款日期
    ,give_money_count number(20,2) -- 放款金额
    ,give_money_product varchar2(400) -- 放款产品
    ,begin_date varchar2(40) -- 创建时间
    ,end_date varchar2(40) -- 结束时间(外呼结果返回日期)
    ,bank_no varchar2(20) -- 银行号
    ,system_no varchar2(20) -- 系统号
    ,is_equal_bus varchar2(2) -- 是否同业标识(0-否 1-是 由发起渠道传送)
    ,priority_grade varchar2(20) -- 优先分数(人工设置)
    ,scene_name varchar2(1000) -- 场景
    ,operator_name varchar2(400) -- 经办人姓名
    ,operator_tel varchar2(64) -- 经办人电话
    ,extend varchar2(64) -- 对公客户号
    ,check_way varchar2(64) -- 查证方式（线上查证、线下查证）
    ,flow_tailafter varchar2(2000) -- 查证流程跟踪
    ,record_tailafter varchar2(400) -- 信息补录跟踪
    ,check_call_user varchar2(400) -- 查证人（拨号人）
    ,check_numbers varchar2(20) -- 外呼中心查证次数
    ,is_overtime varchar2(64) -- 呼叫是否超时限制（是、否）
    ,outcall_launch_time varchar2(40) -- 外呼任务发起时间
    ,record_comment varchar2(600) -- 补录备注（补录结果说明）
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
grant select on ${iol_schema}.scps_bp_phonecheck_tb to ${iml_schema};
grant select on ${iol_schema}.scps_bp_phonecheck_tb to ${icl_schema};
grant select on ${iol_schema}.scps_bp_phonecheck_tb to ${idl_schema};
grant select on ${iol_schema}.scps_bp_phonecheck_tb to ${iel_schema};

-- comment
comment on table ${iol_schema}.scps_bp_phonecheck_tb is '记录企业外呼查证联系信息';
comment on column ${iol_schema}.scps_bp_phonecheck_tb.task_id is '任务号';
comment on column ${iol_schema}.scps_bp_phonecheck_tb.bus_serial_number is '业务流水号';
comment on column ${iol_schema}.scps_bp_phonecheck_tb.cust_id is '客户号';
comment on column ${iol_schema}.scps_bp_phonecheck_tb.cust_name is '客户名称';
comment on column ${iol_schema}.scps_bp_phonecheck_tb.account is '收款账号';
comment on column ${iol_schema}.scps_bp_phonecheck_tb.payee_name is '收款账户名称';
comment on column ${iol_schema}.scps_bp_phonecheck_tb.payer_account is '付款账号';
comment on column ${iol_schema}.scps_bp_phonecheck_tb.payer_name is '付款人名称';
comment on column ${iol_schema}.scps_bp_phonecheck_tb.deal_code is '交易码';
comment on column ${iol_schema}.scps_bp_phonecheck_tb.scene_code is '场景号';
comment on column ${iol_schema}.scps_bp_phonecheck_tb.check_flag is '查证标识（00-免查证，01-待查证，02-查证中，03-查证通过，04-查证不通过，05-无法联系，06-查证异常，07-撤销查证）';
comment on column ${iol_schema}.scps_bp_phonecheck_tb.onesecreason is '二级原因';
comment on column ${iol_schema}.scps_bp_phonecheck_tb.onecheckresult is '查证答案';
comment on column ${iol_schema}.scps_bp_phonecheck_tb.deal_time is '交易日期';
comment on column ${iol_schema}.scps_bp_phonecheck_tb.check_expire_date is '查证到期日';
comment on column ${iol_schema}.scps_bp_phonecheck_tb.check_company is '查证公司';
comment on column ${iol_schema}.scps_bp_phonecheck_tb.amount is '交易金额';
comment on column ${iol_schema}.scps_bp_phonecheck_tb.currency is '币种';
comment on column ${iol_schema}.scps_bp_phonecheck_tb.use is '用途';
comment on column ${iol_schema}.scps_bp_phonecheck_tb.channel is '渠道编号';
comment on column ${iol_schema}.scps_bp_phonecheck_tb.vouchgroup is '凭证组合';
comment on column ${iol_schema}.scps_bp_phonecheck_tb.doc_id is '影像批次号';
comment on column ${iol_schema}.scps_bp_phonecheck_tb.check_type is '查证类型(1-请求查证 2-撤销查证)';
comment on column ${iol_schema}.scps_bp_phonecheck_tb.ticket_issues_date is '票据签发日期';
comment on column ${iol_schema}.scps_bp_phonecheck_tb.trans_bu_ser_no is '办理柜员工号';
comment on column ${iol_schema}.scps_bp_phonecheck_tb.trans_bu_name is '办理柜员姓名';
comment on column ${iol_schema}.scps_bp_phonecheck_tb.trans_bu_phone is '办理柜员电话';
comment on column ${iol_schema}.scps_bp_phonecheck_tb.trans_bu_email is '办理柜员邮箱';
comment on column ${iol_schema}.scps_bp_phonecheck_tb.cust_mgr_no is '客户经理工号';
comment on column ${iol_schema}.scps_bp_phonecheck_tb.cust_mgr_name is '客户经理姓名';
comment on column ${iol_schema}.scps_bp_phonecheck_tb.cust_mgr_phone is '客户经理手机';
comment on column ${iol_schema}.scps_bp_phonecheck_tb.cust_mgr_email is '客户经理邮箱';
comment on column ${iol_schema}.scps_bp_phonecheck_tb.cust_mgr_organ is '客户经理所属机构';
comment on column ${iol_schema}.scps_bp_phonecheck_tb.give_money_date is '放款日期';
comment on column ${iol_schema}.scps_bp_phonecheck_tb.give_money_count is '放款金额';
comment on column ${iol_schema}.scps_bp_phonecheck_tb.give_money_product is '放款产品';
comment on column ${iol_schema}.scps_bp_phonecheck_tb.begin_date is '创建时间';
comment on column ${iol_schema}.scps_bp_phonecheck_tb.end_date is '结束时间(外呼结果返回日期)';
comment on column ${iol_schema}.scps_bp_phonecheck_tb.bank_no is '银行号';
comment on column ${iol_schema}.scps_bp_phonecheck_tb.system_no is '系统号';
comment on column ${iol_schema}.scps_bp_phonecheck_tb.is_equal_bus is '是否同业标识(0-否 1-是 由发起渠道传送)';
comment on column ${iol_schema}.scps_bp_phonecheck_tb.priority_grade is '优先分数(人工设置)';
comment on column ${iol_schema}.scps_bp_phonecheck_tb.scene_name is '场景';
comment on column ${iol_schema}.scps_bp_phonecheck_tb.operator_name is '经办人姓名';
comment on column ${iol_schema}.scps_bp_phonecheck_tb.operator_tel is '经办人电话';
comment on column ${iol_schema}.scps_bp_phonecheck_tb.extend is '对公客户号';
comment on column ${iol_schema}.scps_bp_phonecheck_tb.check_way is '查证方式（线上查证、线下查证）';
comment on column ${iol_schema}.scps_bp_phonecheck_tb.flow_tailafter is '查证流程跟踪';
comment on column ${iol_schema}.scps_bp_phonecheck_tb.record_tailafter is '信息补录跟踪';
comment on column ${iol_schema}.scps_bp_phonecheck_tb.check_call_user is '查证人（拨号人）';
comment on column ${iol_schema}.scps_bp_phonecheck_tb.check_numbers is '外呼中心查证次数';
comment on column ${iol_schema}.scps_bp_phonecheck_tb.is_overtime is '呼叫是否超时限制（是、否）';
comment on column ${iol_schema}.scps_bp_phonecheck_tb.outcall_launch_time is '外呼任务发起时间';
comment on column ${iol_schema}.scps_bp_phonecheck_tb.record_comment is '补录备注（补录结果说明）';
comment on column ${iol_schema}.scps_bp_phonecheck_tb.start_dt is '开始时间';
comment on column ${iol_schema}.scps_bp_phonecheck_tb.end_dt is '结束时间';
comment on column ${iol_schema}.scps_bp_phonecheck_tb.id_mark is '增删标志';
comment on column ${iol_schema}.scps_bp_phonecheck_tb.etl_timestamp is 'ETL处理时间戳';
