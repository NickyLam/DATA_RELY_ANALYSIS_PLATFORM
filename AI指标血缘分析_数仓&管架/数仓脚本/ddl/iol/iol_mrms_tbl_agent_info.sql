/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol mrms_tbl_agent_info
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.mrms_tbl_agent_info
whenever sqlerror continue none;
drop table ${iol_schema}.mrms_tbl_agent_info purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.mrms_tbl_agent_info(
    agent_id varchar2(23) -- 代理商编号
    ,agent_name varchar2(90) -- 代理商名称
    ,agent_short_name varchar2(90) -- 简称
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
    ,comm_tel varchar2(21) -- 联系人电话
    ,post_code varchar2(12) -- 邮编
    ,comm_addr varchar2(90) -- 联系地址
    ,sett_account varchar2(48) -- 结算账户
    ,sett_account_name varchar2(90) -- 结算账户名
    ,sett_account_type varchar2(3) -- 结算账户类型
    ,acct_chnl varchar2(2) -- 入账渠道
    ,open_bank varchar2(90) -- 开户行行号
    ,open_bankname varchar2(384) -- 开户行行名
    ,mcht_feerate_type varchar2(2) -- 旗下商户打款成本收费方式
    ,mcht_feerate varchar2(18) -- 旗下商户打款成本收费值
    ,profit_type varchar2(2) -- 分润收费方式
    ,profit_rate varchar2(18) -- 分润收费值
    ,sett_type varchar2(2) -- 结算方式
    ,sett_cycle varchar2(6) -- 结算周期
    ,agent_status varchar2(2) -- 代理商状态
    ,is_examine varchar2(2) -- 旗下商户是否需要业务审核
    ,sett_mode varchar2(2) -- 清算模式 1：银行二清，2：台账模式
    ,agent_key varchar2(48) -- 秘钥
    ,create_date varchar2(21) -- 新增日期
    ,modfiy_date varchar2(21) -- 最后修改日期
    ,opr_id varchar2(21) -- 操作员
    ,wailian_code varchar2(90) -- 
    ,gateway varchar2(75) -- 
    ,pay_channel varchar2(30) -- 支付渠道：银联“up”,网联“nu”，华兴银行"hx"
    ,reserved varchar2(384) -- 
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
grant select on ${iol_schema}.mrms_tbl_agent_info to ${iml_schema};
grant select on ${iol_schema}.mrms_tbl_agent_info to ${icl_schema};
grant select on ${iol_schema}.mrms_tbl_agent_info to ${idl_schema};
grant select on ${iol_schema}.mrms_tbl_agent_info to ${iel_schema};

-- comment
comment on table ${iol_schema}.mrms_tbl_agent_info is '代理商表';
comment on column ${iol_schema}.mrms_tbl_agent_info.agent_id is '代理商编号';
comment on column ${iol_schema}.mrms_tbl_agent_info.agent_name is '代理商名称';
comment on column ${iol_schema}.mrms_tbl_agent_info.agent_short_name is '简称';
comment on column ${iol_schema}.mrms_tbl_agent_info.acq_inst_id is '所属分行';
comment on column ${iol_schema}.mrms_tbl_agent_info.licence_no is '营业执照号';
comment on column ${iol_schema}.mrms_tbl_agent_info.licence_end_date is '营业执照号有效期';
comment on column ${iol_schema}.mrms_tbl_agent_info.cash_deposit is '保证金';
comment on column ${iol_schema}.mrms_tbl_agent_info.manager is '法人姓名';
comment on column ${iol_schema}.mrms_tbl_agent_info.artif_certif_tp is '证件类型';
comment on column ${iol_schema}.mrms_tbl_agent_info.identity_no is '证件号';
comment on column ${iol_schema}.mrms_tbl_agent_info.manager_tel is '法人手机号';
comment on column ${iol_schema}.mrms_tbl_agent_info.email is '邮箱';
comment on column ${iol_schema}.mrms_tbl_agent_info.contact is '联系人';
comment on column ${iol_schema}.mrms_tbl_agent_info.comm_tel is '联系人电话';
comment on column ${iol_schema}.mrms_tbl_agent_info.post_code is '邮编';
comment on column ${iol_schema}.mrms_tbl_agent_info.comm_addr is '联系地址';
comment on column ${iol_schema}.mrms_tbl_agent_info.sett_account is '结算账户';
comment on column ${iol_schema}.mrms_tbl_agent_info.sett_account_name is '结算账户名';
comment on column ${iol_schema}.mrms_tbl_agent_info.sett_account_type is '结算账户类型';
comment on column ${iol_schema}.mrms_tbl_agent_info.acct_chnl is '入账渠道';
comment on column ${iol_schema}.mrms_tbl_agent_info.open_bank is '开户行行号';
comment on column ${iol_schema}.mrms_tbl_agent_info.open_bankname is '开户行行名';
comment on column ${iol_schema}.mrms_tbl_agent_info.mcht_feerate_type is '旗下商户打款成本收费方式';
comment on column ${iol_schema}.mrms_tbl_agent_info.mcht_feerate is '旗下商户打款成本收费值';
comment on column ${iol_schema}.mrms_tbl_agent_info.profit_type is '分润收费方式';
comment on column ${iol_schema}.mrms_tbl_agent_info.profit_rate is '分润收费值';
comment on column ${iol_schema}.mrms_tbl_agent_info.sett_type is '结算方式';
comment on column ${iol_schema}.mrms_tbl_agent_info.sett_cycle is '结算周期';
comment on column ${iol_schema}.mrms_tbl_agent_info.agent_status is '代理商状态';
comment on column ${iol_schema}.mrms_tbl_agent_info.is_examine is '旗下商户是否需要业务审核';
comment on column ${iol_schema}.mrms_tbl_agent_info.sett_mode is '清算模式 1：银行二清，2：台账模式';
comment on column ${iol_schema}.mrms_tbl_agent_info.agent_key is '秘钥';
comment on column ${iol_schema}.mrms_tbl_agent_info.create_date is '新增日期';
comment on column ${iol_schema}.mrms_tbl_agent_info.modfiy_date is '最后修改日期';
comment on column ${iol_schema}.mrms_tbl_agent_info.opr_id is '操作员';
comment on column ${iol_schema}.mrms_tbl_agent_info.wailian_code is '';
comment on column ${iol_schema}.mrms_tbl_agent_info.gateway is '';
comment on column ${iol_schema}.mrms_tbl_agent_info.pay_channel is '支付渠道：银联“up”,网联“nu”，华兴银行"hx"';
comment on column ${iol_schema}.mrms_tbl_agent_info.reserved is '';
comment on column ${iol_schema}.mrms_tbl_agent_info.start_dt is '开始时间';
comment on column ${iol_schema}.mrms_tbl_agent_info.end_dt is '结束时间';
comment on column ${iol_schema}.mrms_tbl_agent_info.id_mark is '增删标志';
comment on column ${iol_schema}.mrms_tbl_agent_info.etl_timestamp is 'ETL处理时间戳';
