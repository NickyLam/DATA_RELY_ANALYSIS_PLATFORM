/*
Purpose:    应用集市层-建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd itl_itl_edw_evt_priv_onl_bank_tran_flow
CreateDate: 20180515
FileType:   DML
Logs:
    zjj 2018-05-15 新建表本
*/

set timing on

-- 1 alter parallel
alter session force parallel query parallel 4;
alter session force parallel dml parallel 4;
-- alter session force parallel ddl parallel 4;


-- 2.1 drop timeout partition and add partition
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none;
alter table ${itl_schema}.itl_edw_evt_priv_onl_bank_tran_flow drop partition p_${retain_day};
alter table ${itl_schema}.itl_edw_evt_priv_onl_bank_tran_flow drop partition p_${batch_date};

-- 2.2 add today partition
whenever sqlerror exit sql.sqlcode;
alter table ${itl_schema}.itl_edw_evt_priv_onl_bank_tran_flow add  partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

-- 2.3 insert data target table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ into ${itl_schema}.itl_edw_evt_priv_onl_bank_tran_flow partition for (to_date('${batch_date}','yyyymmdd')) (
    etl_dt  -- 数据日期
    ,evt_id  -- 事件编号
    ,lp_id  -- 法人编号
    ,main_flow_num  -- 主流水号
    ,tran_flow_num  -- 交易流水号
    ,ova_flow_num  -- 全局流水号
    ,whole_unify_cust_id  -- 全行统一客户编号
    ,cust_name  -- 客户名称
    ,user_seq_num  -- 用户顺序号
    ,tran_code  -- 交易码
    ,bus_gen_cd  -- 业务大类代码
    ,bus_type_cd  -- 业务类型代码
    ,tran_dt  -- 交易日期
    ,tran_tm  -- 交易时间
    ,tran_acct_num  -- 交易账号
    ,curr_cd  -- 币种代码
    ,tran_amt  -- 交易金额
    ,comm_fee  -- 手续费
    ,sys_id  -- 系统编号
    ,sorc_sys_id  -- 源系统编号
    ,four_chn_cd  -- 四位渠道代码
    ,tran_status_cd  -- 交易状态代码
    ,tran_err_cd  -- 交易错误代码
    ,tran_err_descb  -- 交易错误描述
    ,core_tran_flow_num  -- 核心交易流水号
    ,core_tran_dt  -- 核心交易日期
    ,visit_flow_num  -- 访问流水号
    ,rela_flow_num  -- 关联流水号
    ,proc_server_ip  -- 处理服务器IP
    ,logon_node_id  -- 登陆节点编号
    ,substep_tran_scrt_key  -- 分步交易密钥
    ,tran_comnt  -- 交易说明
    ,tran_type_cd  -- 交易类型代码
    ,func_menu_id  -- 功能菜单编号
    ,client_ip  -- 客户端IP
    ,client_mac  -- 客户端MAC
    ,equip_id  -- 设备编号
    ,equip_brand_name  -- 设备品牌名称
    ,equip_model  -- 设备型号
    ,brow_type_cd  -- 浏览器类型代码
    ,brow_edit_num  -- 浏览器版本号
    ,loitde  -- 经度
    ,dimen  -- 维度
    ,teller_id  -- 柜员编号
    ,teller_belong_org_id  -- 柜员所属机构编号
    ,tran_req_tm  -- 交易请求时间
    ,tran_resp_tm  -- 交易响应时间
    ,etl_timestamp  -- ETL处理时间戳
)
select
    to_date('${batch_date}','yyyymmdd') as etl_dt  -- 数据日期
    ,replace(replace(t1.evt_id,chr(13),''),chr(10),'')  -- 事件编号
    ,replace(replace(t1.lp_id,chr(13),''),chr(10),'')  -- 法人编号
    ,replace(replace(t1.main_flow_num,chr(13),''),chr(10),'')  -- 主流水号
    ,replace(replace(t1.tran_flow_num,chr(13),''),chr(10),'')  -- 交易流水号
    ,replace(replace(t1.ova_flow_num,chr(13),''),chr(10),'')  -- 全局流水号
    ,replace(replace(t1.whole_unify_cust_id,chr(13),''),chr(10),'')  -- 全行统一客户编号
    ,replace(replace(t1.cust_name,chr(13),''),chr(10),'')  -- 客户名称
    ,replace(replace(t1.user_seq_num,chr(13),''),chr(10),'')  -- 用户顺序号
    ,replace(replace(t1.tran_code,chr(13),''),chr(10),'')  -- 交易码
    ,replace(replace(t1.bus_gen_cd,chr(13),''),chr(10),'')  -- 业务大类代码
    ,replace(replace(t1.bus_type_cd,chr(13),''),chr(10),'')  -- 业务类型代码
    ,t1.tran_dt  -- 交易日期
    ,replace(replace(t1.tran_tm,chr(13),''),chr(10),'')  -- 交易时间
    ,replace(replace(t1.tran_acct_num,chr(13),''),chr(10),'')  -- 交易账号
    ,replace(replace(t1.curr_cd,chr(13),''),chr(10),'')  -- 币种代码
    ,t1.tran_amt  -- 交易金额
    ,t1.comm_fee  -- 手续费
    ,replace(replace(t1.sys_id,chr(13),''),chr(10),'')  -- 系统编号
    ,replace(replace(t1.sorc_sys_id,chr(13),''),chr(10),'')  -- 源系统编号
    ,replace(replace(t1.four_chn_cd,chr(13),''),chr(10),'')  -- 四位渠道代码
    ,replace(replace(t1.tran_status_cd,chr(13),''),chr(10),'')  -- 交易状态代码
    ,replace(replace(t1.tran_err_cd,chr(13),''),chr(10),'')  -- 交易错误代码
    ,replace(replace(t1.tran_err_descb,chr(13),''),chr(10),'')  -- 交易错误描述
    ,replace(replace(t1.core_tran_flow_num,chr(13),''),chr(10),'')  -- 核心交易流水号
    ,t1.core_tran_dt  -- 核心交易日期
    ,replace(replace(t1.visit_flow_num,chr(13),''),chr(10),'')  -- 访问流水号
    ,replace(replace(t1.rela_flow_num,chr(13),''),chr(10),'')  -- 关联流水号
    ,replace(replace(t1.proc_server_ip,chr(13),''),chr(10),'')  -- 处理服务器IP
    ,replace(replace(t1.logon_node_id,chr(13),''),chr(10),'')  -- 登陆节点编号
    ,replace(replace(t1.substep_tran_scrt_key,chr(13),''),chr(10),'')  -- 分步交易密钥
    ,replace(replace(t1.tran_comnt,chr(13),''),chr(10),'')  -- 交易说明
    ,replace(replace(t1.tran_type_cd,chr(13),''),chr(10),'')  -- 交易类型代码
    ,replace(replace(t1.func_menu_id,chr(13),''),chr(10),'')  -- 功能菜单编号
    ,replace(replace(t1.client_ip,chr(13),''),chr(10),'')  -- 客户端IP
    ,replace(replace(t1.client_mac,chr(13),''),chr(10),'')  -- 客户端MAC
    ,replace(replace(t1.equip_id,chr(13),''),chr(10),'')  -- 设备编号
    ,replace(replace(t1.equip_brand_name,chr(13),''),chr(10),'')  -- 设备品牌名称
    ,replace(replace(t1.equip_model,chr(13),''),chr(10),'')  -- 设备型号
    ,replace(replace(t1.brow_type_cd,chr(13),''),chr(10),'')  -- 浏览器类型代码
    ,replace(replace(t1.brow_edit_num,chr(13),''),chr(10),'')  -- 浏览器版本号
    ,replace(replace(t1.loitde,chr(13),''),chr(10),'')  -- 经度
    ,replace(replace(t1.dimen,chr(13),''),chr(10),'')  -- 维度
    ,replace(replace(t1.teller_id,chr(13),''),chr(10),'')  -- 柜员编号
    ,replace(replace(t1.teller_belong_org_id,chr(13),''),chr(10),'')  -- 柜员所属机构编号
    ,t1.tran_req_tm  -- 交易请求时间
    ,t1.tran_resp_tm  -- 交易响应时间
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp  -- ETL处理时间戳
from ${msl_schema}.msl_edw_evt_priv_onl_bank_tran_flow t1    --对私网上银行交易流水
where t1.etl_dt = to_date('${batch_date}','yyyymmdd')
and   t1.tran_dt =to_date('${batch_date}','yyyymmdd'); 
commit;


-- 4 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${itl_schema}',tabname => 'itl_edw_evt_priv_onl_bank_tran_flow',partname => 'p_${batch_date}', granularity => 'PARTITION', degree => 8, cascade => true);