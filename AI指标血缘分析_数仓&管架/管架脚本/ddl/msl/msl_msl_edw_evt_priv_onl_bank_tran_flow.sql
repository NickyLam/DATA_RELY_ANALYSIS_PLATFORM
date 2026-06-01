/*
Purpose:    技术缓冲层-建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py msl msl_edw_evt_priv_onl_bank_tran_flow
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${msl_schema}.msl_edw_evt_priv_onl_bank_tran_flow
whenever sqlerror continue none;
drop table ${msl_schema}.msl_edw_evt_priv_onl_bank_tran_flow purge;

whenever sqlerror exit sql.sqlcode;
create table ${msl_schema}.msl_edw_evt_priv_onl_bank_tran_flow(
    etl_dt date
    ,evt_id varchar2(200)
    ,lp_id varchar2(60)
    ,main_flow_num varchar2(200)
    ,tran_flow_num varchar2(100)
    ,ova_flow_num varchar2(60)
    ,whole_unify_cust_id varchar2(60)
    ,cust_name varchar2(200)
    ,user_seq_num varchar2(60)
    ,tran_code varchar2(100)
    ,bus_gen_cd varchar2(100)
    ,bus_type_cd varchar2(100)
    ,tran_dt date
    ,tran_tm varchar2(10)
    ,tran_acct_num varchar2(200)
    ,curr_cd varchar2(10)
    ,tran_amt number(30,2)
    ,comm_fee number(30,2)
    ,sys_id varchar2(60)
    ,sorc_sys_id varchar2(60)
    ,four_chn_cd varchar2(10)
    ,tran_status_cd varchar2(10)
    ,tran_err_cd varchar2(200)
    ,tran_err_descb varchar2(2000)
    ,core_tran_flow_num varchar2(60)
    ,core_tran_dt date
    ,visit_flow_num varchar2(60)
    ,rela_flow_num varchar2(100)
    ,proc_server_ip varchar2(60)
    ,logon_node_id varchar2(200)
    ,substep_tran_scrt_key varchar2(200)
    ,tran_comnt varchar2(2000)
    ,tran_type_cd varchar2(100)
    ,func_menu_id varchar2(60)
    ,client_ip varchar2(250)
    ,client_mac varchar2(60)
    ,equip_id varchar2(200)
    ,equip_brand_name varchar2(100)
    ,equip_model varchar2(100)
    ,brow_type_cd varchar2(100)
    ,brow_edit_num varchar2(100)
    ,loitde varchar2(60)
    ,dimen varchar2(60)
    ,teller_id varchar2(60)
    ,teller_belong_org_id varchar2(60)
    ,tran_req_tm timestamp
    ,tran_resp_tm timestamp
    ,tran_order_no varchar2(60)
    ,chain_way_track_no varchar2(500)
    ,sys_flow_num varchar2(100)
    ,chn_id varchar2(30)
)
storage (initial 1024k next 1024k)
compress nologging
;

-- grant
grant select on ${msl_schema}.msl_edw_evt_priv_onl_bank_tran_flow to ${itl_schema};

-- comment
comment on table ${msl_schema}.msl_edw_evt_priv_onl_bank_tran_flow is '对私网上银行交易流水';
comment on column ${msl_schema}.msl_edw_evt_priv_onl_bank_tran_flow.etl_dt is '数据日期';
comment on column ${msl_schema}.msl_edw_evt_priv_onl_bank_tran_flow.evt_id is '事件编号';
comment on column ${msl_schema}.msl_edw_evt_priv_onl_bank_tran_flow.lp_id is '法人编号';
comment on column ${msl_schema}.msl_edw_evt_priv_onl_bank_tran_flow.main_flow_num is '主流水号';
comment on column ${msl_schema}.msl_edw_evt_priv_onl_bank_tran_flow.tran_flow_num is '交易流水号';
comment on column ${msl_schema}.msl_edw_evt_priv_onl_bank_tran_flow.ova_flow_num is '全局流水号';
comment on column ${msl_schema}.msl_edw_evt_priv_onl_bank_tran_flow.whole_unify_cust_id is '全行统一客户编号';
comment on column ${msl_schema}.msl_edw_evt_priv_onl_bank_tran_flow.cust_name is '客户名称';
comment on column ${msl_schema}.msl_edw_evt_priv_onl_bank_tran_flow.user_seq_num is '用户顺序号';
comment on column ${msl_schema}.msl_edw_evt_priv_onl_bank_tran_flow.tran_code is '交易码';
comment on column ${msl_schema}.msl_edw_evt_priv_onl_bank_tran_flow.bus_gen_cd is '业务大类代码';
comment on column ${msl_schema}.msl_edw_evt_priv_onl_bank_tran_flow.bus_type_cd is '业务类型代码';
comment on column ${msl_schema}.msl_edw_evt_priv_onl_bank_tran_flow.tran_dt is '交易日期';
comment on column ${msl_schema}.msl_edw_evt_priv_onl_bank_tran_flow.tran_tm is '交易时间';
comment on column ${msl_schema}.msl_edw_evt_priv_onl_bank_tran_flow.tran_acct_num is '交易账号';
comment on column ${msl_schema}.msl_edw_evt_priv_onl_bank_tran_flow.curr_cd is '币种代码';
comment on column ${msl_schema}.msl_edw_evt_priv_onl_bank_tran_flow.tran_amt is '交易金额';
comment on column ${msl_schema}.msl_edw_evt_priv_onl_bank_tran_flow.comm_fee is '手续费';
comment on column ${msl_schema}.msl_edw_evt_priv_onl_bank_tran_flow.sys_id is '系统编号';
comment on column ${msl_schema}.msl_edw_evt_priv_onl_bank_tran_flow.sorc_sys_id is '源系统编号';
comment on column ${msl_schema}.msl_edw_evt_priv_onl_bank_tran_flow.four_chn_cd is '四位渠道代码';
comment on column ${msl_schema}.msl_edw_evt_priv_onl_bank_tran_flow.tran_status_cd is '交易状态代码';
comment on column ${msl_schema}.msl_edw_evt_priv_onl_bank_tran_flow.tran_err_cd is '交易错误代码';
comment on column ${msl_schema}.msl_edw_evt_priv_onl_bank_tran_flow.tran_err_descb is '交易错误描述';
comment on column ${msl_schema}.msl_edw_evt_priv_onl_bank_tran_flow.core_tran_flow_num is '核心交易流水号';
comment on column ${msl_schema}.msl_edw_evt_priv_onl_bank_tran_flow.core_tran_dt is '核心交易日期';
comment on column ${msl_schema}.msl_edw_evt_priv_onl_bank_tran_flow.visit_flow_num is '访问流水号';
comment on column ${msl_schema}.msl_edw_evt_priv_onl_bank_tran_flow.rela_flow_num is '关联流水号';
comment on column ${msl_schema}.msl_edw_evt_priv_onl_bank_tran_flow.proc_server_ip is '处理服务器ip';
comment on column ${msl_schema}.msl_edw_evt_priv_onl_bank_tran_flow.logon_node_id is '登陆节点编号';
comment on column ${msl_schema}.msl_edw_evt_priv_onl_bank_tran_flow.substep_tran_scrt_key is '分步交易密钥';
comment on column ${msl_schema}.msl_edw_evt_priv_onl_bank_tran_flow.tran_comnt is '交易说明';
comment on column ${msl_schema}.msl_edw_evt_priv_onl_bank_tran_flow.tran_type_cd is '交易类型代码';
comment on column ${msl_schema}.msl_edw_evt_priv_onl_bank_tran_flow.func_menu_id is '功能菜单编号';
comment on column ${msl_schema}.msl_edw_evt_priv_onl_bank_tran_flow.client_ip is '客户端ip';
comment on column ${msl_schema}.msl_edw_evt_priv_onl_bank_tran_flow.client_mac is '客户端mac';
comment on column ${msl_schema}.msl_edw_evt_priv_onl_bank_tran_flow.equip_id is '设备编号';
comment on column ${msl_schema}.msl_edw_evt_priv_onl_bank_tran_flow.equip_brand_name is '设备品牌名称';
comment on column ${msl_schema}.msl_edw_evt_priv_onl_bank_tran_flow.equip_model is '设备型号';
comment on column ${msl_schema}.msl_edw_evt_priv_onl_bank_tran_flow.brow_type_cd is '浏览器类型代码';
comment on column ${msl_schema}.msl_edw_evt_priv_onl_bank_tran_flow.brow_edit_num is '浏览器版本号';
comment on column ${msl_schema}.msl_edw_evt_priv_onl_bank_tran_flow.loitde is '经度';
comment on column ${msl_schema}.msl_edw_evt_priv_onl_bank_tran_flow.dimen is '维度';
comment on column ${msl_schema}.msl_edw_evt_priv_onl_bank_tran_flow.teller_id is '柜员编号';
comment on column ${msl_schema}.msl_edw_evt_priv_onl_bank_tran_flow.teller_belong_org_id is '柜员所属机构编号';
comment on column ${msl_schema}.msl_edw_evt_priv_onl_bank_tran_flow.tran_req_tm is '交易请求时间';
comment on column ${msl_schema}.msl_edw_evt_priv_onl_bank_tran_flow.tran_resp_tm is '交易响应时间';
comment on column ${msl_schema}.msl_edw_evt_priv_onl_bank_tran_flow.tran_order_no is '交易订单号';
comment on column ${msl_schema}.msl_edw_evt_priv_onl_bank_tran_flow.chain_way_track_no is '链路跟踪号';
comment on column ${msl_schema}.msl_edw_evt_priv_onl_bank_tran_flow.sys_flow_num is '系统流水号';
comment on column ${msl_schema}.msl_edw_evt_priv_onl_bank_tran_flow.chn_id is '渠道编号';
