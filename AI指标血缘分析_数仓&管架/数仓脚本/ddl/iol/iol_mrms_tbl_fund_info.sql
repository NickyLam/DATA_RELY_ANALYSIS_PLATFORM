/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol mrms_tbl_fund_info
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.mrms_tbl_fund_info
whenever sqlerror continue none;
drop table ${iol_schema}.mrms_tbl_fund_info purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.mrms_tbl_fund_info(
    fund_id varchar2(23) -- 基金编号
    ,fund_name varchar2(225) -- 基金名称
    ,fund_short_name varchar2(90) -- 简称
    ,channel_id varchar2(30) -- 渠道编号
    ,agent_id varchar2(23) -- 代理商编号
    ,pro_type varchar2(2) -- 产品类型 0：智慧校园，1：全渠道代付
    ,acq_inst_id varchar2(18) -- 所属分行
    ,licence_no varchar2(48) -- 营业执照号
    ,licence_end_date varchar2(21) -- 营业执照号有效期
    ,cash_deposit number(22,2) -- 保证金
    ,manager varchar2(90) -- 法人姓名
    ,artif_certif_tp varchar2(30) -- 证件类型
    ,identity_no varchar2(27) -- 证件号
    ,manager_tel varchar2(21) -- 法人手机号
    ,email varchar2(90) -- 邮箱
    ,contact varchar2(90) -- 联系人
    ,conm_certif_tp varchar2(30) -- 联系人证件类型
    ,conm_identity_no varchar2(27) -- 联系人证件号
    ,comm_tel varchar2(21) -- 联系人电话
    ,post_code varchar2(12) -- 邮编
    ,comm_addr varchar2(90) -- 联系地址
    ,sett_account varchar2(48) -- 结算账户
    ,sett_account_name varchar2(90) -- 结算账户名
    ,sett_account_type varchar2(2) -- 结算账户类型
    ,acct_chnl varchar2(2) -- 入账渠道
    ,open_bank varchar2(90) -- 开户行行号
    ,open_bankname varchar2(384) -- 开户行行名
    ,open_acct_addr varchar2(768) -- 开户地址
    ,fund_status varchar2(2) -- 基金状态0 正常,1 添加待审核,2 审核不通过 3 修改待审核,5 冻结待审核,6 冻结7 恢复待审核8 注销9 注销待审核
    ,rcv_account varchar2(48) -- 收款账号
    ,rcv_account_name varchar2(90) -- 收款账户名称
    ,create_date varchar2(21) -- 新增日期
    ,modfiy_date varchar2(21) -- 最后修改日期
    ,opr_id varchar2(21) -- 操作员
    ,api_id varchar2(24) -- api系统标识
    ,cushion_acct varchar2(48) -- 垫资账户
    ,cushion_acct_name varchar2(90) -- 垫资账户名
    ,fund_amt number(15,2) -- 基金额度
    ,sing_limit number(15,2) -- 单笔限额
    ,used_amt number(15,2) -- 已使用额度
    ,trand_amt number(15,2) -- 代付还款额度
    ,cushion_amt number(15,2) -- 垫资金额
    ,last_used_amt number(15,2) -- 上次使用额度
    ,rcv_acct_type varchar2(2) -- 收款账户类型 0:内部账号 1一类账号 2二类账号
    ,cushion_acct_type varchar2(2) -- 垫资账户类型 0:内部账号 1一类账号 2二类账号
    ,sms_phone varchar2(17) -- 短信通知手机号
    ,sms_name varchar2(27) -- 短信通知姓名
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
grant select on ${iol_schema}.mrms_tbl_fund_info to ${iml_schema};
grant select on ${iol_schema}.mrms_tbl_fund_info to ${icl_schema};
grant select on ${iol_schema}.mrms_tbl_fund_info to ${idl_schema};
grant select on ${iol_schema}.mrms_tbl_fund_info to ${iel_schema};

-- comment
comment on table ${iol_schema}.mrms_tbl_fund_info is '基金公司信息表(协议单位信息表)';
comment on column ${iol_schema}.mrms_tbl_fund_info.fund_id is '基金编号';
comment on column ${iol_schema}.mrms_tbl_fund_info.fund_name is '基金名称';
comment on column ${iol_schema}.mrms_tbl_fund_info.fund_short_name is '简称';
comment on column ${iol_schema}.mrms_tbl_fund_info.channel_id is '渠道编号';
comment on column ${iol_schema}.mrms_tbl_fund_info.agent_id is '代理商编号';
comment on column ${iol_schema}.mrms_tbl_fund_info.pro_type is '产品类型 0：智慧校园，1：全渠道代付';
comment on column ${iol_schema}.mrms_tbl_fund_info.acq_inst_id is '所属分行';
comment on column ${iol_schema}.mrms_tbl_fund_info.licence_no is '营业执照号';
comment on column ${iol_schema}.mrms_tbl_fund_info.licence_end_date is '营业执照号有效期';
comment on column ${iol_schema}.mrms_tbl_fund_info.cash_deposit is '保证金';
comment on column ${iol_schema}.mrms_tbl_fund_info.manager is '法人姓名';
comment on column ${iol_schema}.mrms_tbl_fund_info.artif_certif_tp is '证件类型';
comment on column ${iol_schema}.mrms_tbl_fund_info.identity_no is '证件号';
comment on column ${iol_schema}.mrms_tbl_fund_info.manager_tel is '法人手机号';
comment on column ${iol_schema}.mrms_tbl_fund_info.email is '邮箱';
comment on column ${iol_schema}.mrms_tbl_fund_info.contact is '联系人';
comment on column ${iol_schema}.mrms_tbl_fund_info.conm_certif_tp is '联系人证件类型';
comment on column ${iol_schema}.mrms_tbl_fund_info.conm_identity_no is '联系人证件号';
comment on column ${iol_schema}.mrms_tbl_fund_info.comm_tel is '联系人电话';
comment on column ${iol_schema}.mrms_tbl_fund_info.post_code is '邮编';
comment on column ${iol_schema}.mrms_tbl_fund_info.comm_addr is '联系地址';
comment on column ${iol_schema}.mrms_tbl_fund_info.sett_account is '结算账户';
comment on column ${iol_schema}.mrms_tbl_fund_info.sett_account_name is '结算账户名';
comment on column ${iol_schema}.mrms_tbl_fund_info.sett_account_type is '结算账户类型';
comment on column ${iol_schema}.mrms_tbl_fund_info.acct_chnl is '入账渠道';
comment on column ${iol_schema}.mrms_tbl_fund_info.open_bank is '开户行行号';
comment on column ${iol_schema}.mrms_tbl_fund_info.open_bankname is '开户行行名';
comment on column ${iol_schema}.mrms_tbl_fund_info.open_acct_addr is '开户地址';
comment on column ${iol_schema}.mrms_tbl_fund_info.fund_status is '基金状态0 正常,1 添加待审核,2 审核不通过 3 修改待审核,5 冻结待审核,6 冻结7 恢复待审核8 注销9 注销待审核';
comment on column ${iol_schema}.mrms_tbl_fund_info.rcv_account is '收款账号';
comment on column ${iol_schema}.mrms_tbl_fund_info.rcv_account_name is '收款账户名称';
comment on column ${iol_schema}.mrms_tbl_fund_info.create_date is '新增日期';
comment on column ${iol_schema}.mrms_tbl_fund_info.modfiy_date is '最后修改日期';
comment on column ${iol_schema}.mrms_tbl_fund_info.opr_id is '操作员';
comment on column ${iol_schema}.mrms_tbl_fund_info.api_id is 'api系统标识';
comment on column ${iol_schema}.mrms_tbl_fund_info.cushion_acct is '垫资账户';
comment on column ${iol_schema}.mrms_tbl_fund_info.cushion_acct_name is '垫资账户名';
comment on column ${iol_schema}.mrms_tbl_fund_info.fund_amt is '基金额度';
comment on column ${iol_schema}.mrms_tbl_fund_info.sing_limit is '单笔限额';
comment on column ${iol_schema}.mrms_tbl_fund_info.used_amt is '已使用额度';
comment on column ${iol_schema}.mrms_tbl_fund_info.trand_amt is '代付还款额度';
comment on column ${iol_schema}.mrms_tbl_fund_info.cushion_amt is '垫资金额';
comment on column ${iol_schema}.mrms_tbl_fund_info.last_used_amt is '上次使用额度';
comment on column ${iol_schema}.mrms_tbl_fund_info.rcv_acct_type is '收款账户类型 0:内部账号 1一类账号 2二类账号';
comment on column ${iol_schema}.mrms_tbl_fund_info.cushion_acct_type is '垫资账户类型 0:内部账号 1一类账号 2二类账号';
comment on column ${iol_schema}.mrms_tbl_fund_info.sms_phone is '短信通知手机号';
comment on column ${iol_schema}.mrms_tbl_fund_info.sms_name is '短信通知姓名';
comment on column ${iol_schema}.mrms_tbl_fund_info.start_dt is '开始时间';
comment on column ${iol_schema}.mrms_tbl_fund_info.end_dt is '结束时间';
comment on column ${iol_schema}.mrms_tbl_fund_info.id_mark is '增删标志';
comment on column ${iol_schema}.mrms_tbl_fund_info.etl_timestamp is 'ETL处理时间戳';
