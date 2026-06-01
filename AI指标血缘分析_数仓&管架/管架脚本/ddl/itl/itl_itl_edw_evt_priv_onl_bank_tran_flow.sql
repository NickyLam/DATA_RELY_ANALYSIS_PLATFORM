/*
Purpose:    应用集市层-建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py itl itl_edw_evt_priv_onl_bank_tran_flow
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${itl_schema}.itl_edw_evt_priv_onl_bank_tran_flow
whenever sqlerror continue none;
drop table ${itl_schema}.itl_edw_evt_priv_onl_bank_tran_flow purge;

whenever sqlerror exit sql.sqlcode;
create table ${itl_schema}.itl_edw_evt_priv_onl_bank_tran_flow(
    etl_dt date -- 数据日期
    ,evt_id varchar2(200) -- 事件编号
    ,lp_id varchar2(60) -- 法人编号
    ,main_flow_num varchar2(200) -- 主流水号
    ,tran_flow_num varchar2(60) -- 交易流水号
    ,ova_flow_num varchar2(60) -- 全局流水号
    ,whole_unify_cust_id varchar2(60) -- 全行统一客户编号
    ,cust_name varchar2(200) -- 客户名称
    ,user_seq_num varchar2(60) -- 用户顺序号
    ,tran_code varchar2(100) -- 交易码
    ,bus_gen_cd varchar2(100) -- 业务大类代码
    ,bus_type_cd varchar2(100) -- 业务类型代码
    ,tran_dt date -- 交易日期
    ,tran_tm varchar2(10) -- 交易时间
    ,tran_acct_num varchar2(200) -- 交易账号
    ,curr_cd varchar2(10) -- 币种代码
    ,tran_amt number(30,2) -- 交易金额
    ,comm_fee number(30,2) -- 手续费
    ,sys_id varchar2(60) -- 系统编号
    ,sorc_sys_id varchar2(60) -- 源系统编号
    ,four_chn_cd varchar2(10) -- 四位渠道代码
    ,tran_status_cd varchar2(10) -- 交易状态代码
    ,tran_err_cd varchar2(200) -- 交易错误代码
    ,tran_err_descb varchar2(2000) -- 交易错误描述
    ,core_tran_flow_num varchar2(60) -- 核心交易流水号
    ,core_tran_dt date -- 核心交易日期
    ,visit_flow_num varchar2(60) -- 访问流水号
    ,rela_flow_num varchar2(60) -- 关联流水号
    ,proc_server_ip varchar2(60) -- 处理服务器IP
    ,logon_node_id varchar2(200) -- 登陆节点编号
    ,substep_tran_scrt_key varchar2(200) -- 分步交易密钥
    ,tran_comnt varchar2(2000) -- 交易说明
    ,tran_type_cd varchar2(100) -- 交易类型代码
    ,func_menu_id varchar2(60) -- 功能菜单编号
    ,client_ip varchar2(60) -- 客户端IP
    ,client_mac varchar2(60) -- 客户端MAC
    ,equip_id varchar2(200) -- 设备编号
    ,equip_brand_name varchar2(100) -- 设备品牌名称
    ,equip_model varchar2(100) -- 设备型号
    ,brow_type_cd varchar2(100) -- 浏览器类型代码
    ,brow_edit_num varchar2(100) -- 浏览器版本号
    ,loitde varchar2(60) -- 经度
    ,dimen varchar2(60) -- 维度
    ,teller_id varchar2(60) -- 柜员编号
    ,teller_belong_org_id varchar2(60) -- 柜员所属机构编号
    ,tran_req_tm timestamp -- 交易请求时间
    ,tran_resp_tm timestamp -- 交易响应时间
    ,etl_timestamp timestamp -- ETL处理时间戳
   -- ,job_cd varchar2(10) -- 任务编码
   -- ,etl_timestamp timestamp -- ETL处理时间戳
)
partition by list(etl_dt)(
    partition p_19000101 values (to_date('19000101','yyyymmdd'))
)
storage (initial 1024k next 1024k)
compress ${option_switch} for query high
nologging
;

-- grant
grant select on ${itl_schema}.itl_edw_evt_priv_onl_bank_tran_flow to ${iel_schema};

-- comment
comment on table ${itl_schema}.itl_edw_evt_priv_onl_bank_tran_flow is '对私网上银行交易流水';
comment on column ${itl_schema}.itl_edw_evt_priv_onl_bank_tran_flow.etl_dt is '数据日期';
comment on column ${itl_schema}.itl_edw_evt_priv_onl_bank_tran_flow.evt_id is '事件编号';
comment on column ${itl_schema}.itl_edw_evt_priv_onl_bank_tran_flow.lp_id is '法人编号';
comment on column ${itl_schema}.itl_edw_evt_priv_onl_bank_tran_flow.main_flow_num is '主流水号';
comment on column ${itl_schema}.itl_edw_evt_priv_onl_bank_tran_flow.tran_flow_num is '交易流水号';
comment on column ${itl_schema}.itl_edw_evt_priv_onl_bank_tran_flow.ova_flow_num is '全局流水号';
comment on column ${itl_schema}.itl_edw_evt_priv_onl_bank_tran_flow.whole_unify_cust_id is '全行统一客户编号';
comment on column ${itl_schema}.itl_edw_evt_priv_onl_bank_tran_flow.cust_name is '客户名称';
comment on column ${itl_schema}.itl_edw_evt_priv_onl_bank_tran_flow.user_seq_num is '用户顺序号';
comment on column ${itl_schema}.itl_edw_evt_priv_onl_bank_tran_flow.tran_code is '交易码';
comment on column ${itl_schema}.itl_edw_evt_priv_onl_bank_tran_flow.bus_gen_cd is '业务大类代码';
comment on column ${itl_schema}.itl_edw_evt_priv_onl_bank_tran_flow.bus_type_cd is '业务类型代码';
comment on column ${itl_schema}.itl_edw_evt_priv_onl_bank_tran_flow.tran_dt is '交易日期';
comment on column ${itl_schema}.itl_edw_evt_priv_onl_bank_tran_flow.tran_tm is '交易时间';
comment on column ${itl_schema}.itl_edw_evt_priv_onl_bank_tran_flow.tran_acct_num is '交易账号';
comment on column ${itl_schema}.itl_edw_evt_priv_onl_bank_tran_flow.curr_cd is '币种代码';
comment on column ${itl_schema}.itl_edw_evt_priv_onl_bank_tran_flow.tran_amt is '交易金额';
comment on column ${itl_schema}.itl_edw_evt_priv_onl_bank_tran_flow.comm_fee is '手续费';
comment on column ${itl_schema}.itl_edw_evt_priv_onl_bank_tran_flow.sys_id is '系统编号';
comment on column ${itl_schema}.itl_edw_evt_priv_onl_bank_tran_flow.sorc_sys_id is '源系统编号';
comment on column ${itl_schema}.itl_edw_evt_priv_onl_bank_tran_flow.four_chn_cd is '四位渠道代码';
comment on column ${itl_schema}.itl_edw_evt_priv_onl_bank_tran_flow.tran_status_cd is '交易状态代码';
comment on column ${itl_schema}.itl_edw_evt_priv_onl_bank_tran_flow.tran_err_cd is '交易错误代码';
comment on column ${itl_schema}.itl_edw_evt_priv_onl_bank_tran_flow.tran_err_descb is '交易错误描述';
comment on column ${itl_schema}.itl_edw_evt_priv_onl_bank_tran_flow.core_tran_flow_num is '核心交易流水号';
comment on column ${itl_schema}.itl_edw_evt_priv_onl_bank_tran_flow.core_tran_dt is '核心交易日期';
comment on column ${itl_schema}.itl_edw_evt_priv_onl_bank_tran_flow.visit_flow_num is '访问流水号';
comment on column ${itl_schema}.itl_edw_evt_priv_onl_bank_tran_flow.rela_flow_num is '关联流水号';
comment on column ${itl_schema}.itl_edw_evt_priv_onl_bank_tran_flow.proc_server_ip is '处理服务器IP';
comment on column ${itl_schema}.itl_edw_evt_priv_onl_bank_tran_flow.logon_node_id is '登陆节点编号';
comment on column ${itl_schema}.itl_edw_evt_priv_onl_bank_tran_flow.substep_tran_scrt_key is '分步交易密钥';
comment on column ${itl_schema}.itl_edw_evt_priv_onl_bank_tran_flow.tran_comnt is '交易说明';
comment on column ${itl_schema}.itl_edw_evt_priv_onl_bank_tran_flow.tran_type_cd is '交易类型代码';
comment on column ${itl_schema}.itl_edw_evt_priv_onl_bank_tran_flow.func_menu_id is '功能菜单编号';
comment on column ${itl_schema}.itl_edw_evt_priv_onl_bank_tran_flow.client_ip is '客户端IP';
comment on column ${itl_schema}.itl_edw_evt_priv_onl_bank_tran_flow.client_mac is '客户端MAC';
comment on column ${itl_schema}.itl_edw_evt_priv_onl_bank_tran_flow.equip_id is '设备编号';
comment on column ${itl_schema}.itl_edw_evt_priv_onl_bank_tran_flow.equip_brand_name is '设备品牌名称';
comment on column ${itl_schema}.itl_edw_evt_priv_onl_bank_tran_flow.equip_model is '设备型号';
comment on column ${itl_schema}.itl_edw_evt_priv_onl_bank_tran_flow.brow_type_cd is '浏览器类型代码';
comment on column ${itl_schema}.itl_edw_evt_priv_onl_bank_tran_flow.brow_edit_num is '浏览器版本号';
comment on column ${itl_schema}.itl_edw_evt_priv_onl_bank_tran_flow.loitde is '经度';
comment on column ${itl_schema}.itl_edw_evt_priv_onl_bank_tran_flow.dimen is '维度';
comment on column ${itl_schema}.itl_edw_evt_priv_onl_bank_tran_flow.teller_id is '柜员编号';
comment on column ${itl_schema}.itl_edw_evt_priv_onl_bank_tran_flow.teller_belong_org_id is '柜员所属机构编号';
comment on column ${itl_schema}.itl_edw_evt_priv_onl_bank_tran_flow.tran_req_tm is '交易请求时间';
comment on column ${itl_schema}.itl_edw_evt_priv_onl_bank_tran_flow.tran_resp_tm is '交易响应时间';
comment on column ${itl_schema}.itl_edw_evt_priv_onl_bank_tran_flow.etl_timestamp is 'ETL处理时间戳';