/*
Purpose:    整全模型层-增量流水脚本，清空目标表当天分区数据，把当天数据与目标表进行分区交换。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iml_evt_priv_onl_bank_tran_flow_osbsi1
CreateDate: 20180515
Logs:
    zjj 2018-05-15 新建表本
*/

set timing on

-- 1 alter parallel
alter session force parallel query parallel 4;
alter session force parallel dml parallel 4;
-- alter session force parallel ddl parallel 1;

-- 2.1 create table for exchage and add partition
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iml_schema}.evt_priv_onl_bank_tran_flow_osbsi1_tm purge;
alter table ${iml_schema}.evt_priv_onl_bank_tran_flow add partition p_osbsi1 values ('osbsi1')(
        subpartition p_osbsi1_${batch_date} values (to_date('${batch_date}','yyyymmdd'))
    )
;
alter table ${iml_schema}.evt_priv_onl_bank_tran_flow modify partition p_osbsi1
    add subpartition p_osbsi1_${batch_date} values (to_date('${batch_date}','yyyymmdd'))
;

whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.evt_priv_onl_bank_tran_flow_osbsi1_tm
compress ${option_switch} for query high
as
select
    evt_id -- 事件编号
    ,lp_id -- 法人编号
    ,main_flow_num -- 主流水号
    ,tran_flow_num -- 交易流水号
    ,ova_flow_num -- 全局流水号
    ,whole_unify_cust_id -- 全行统一客户编号
    ,cust_name -- 客户名称
    ,user_seq_num -- 用户顺序号
    ,tran_code -- 交易码
    ,bus_gen_cd -- 业务大类代码
    ,bus_type_cd -- 业务类型代码
    ,tran_dt -- 交易日期
    ,tran_tm -- 交易时间
    ,tran_acct_num -- 交易账号
    ,curr_cd -- 币种代码
    ,tran_amt -- 交易金额
    ,comm_fee -- 手续费
    ,sys_id -- 系统编号
    ,sorc_sys_id -- 源系统编号
    ,four_chn_cd -- 四位渠道代码
    ,tran_status_cd -- 交易状态代码
    ,tran_err_cd -- 交易错误代码
    ,tran_err_descb -- 交易错误描述
    ,core_tran_flow_num -- 核心交易流水号
    ,core_tran_dt -- 核心交易日期
    ,visit_flow_num -- 访问流水号
    ,rela_flow_num -- 关联流水号
    ,proc_server_ip -- 处理服务器IP
    ,logon_node_id -- 登陆节点编号
    ,substep_tran_scrt_key -- 分步交易密钥
    ,tran_comnt -- 交易说明
    ,tran_type_cd -- 交易类型代码
    ,func_menu_id -- 功能菜单编号
    ,client_ip -- 客户端IP
    ,client_mac -- 客户端MAC
    ,equip_id -- 设备编号
    ,equip_brand_name -- 设备品牌名称
    ,equip_model -- 设备型号
    ,brow_type_cd -- 浏览器类型代码
    ,brow_edit_num -- 浏览器版本号
    ,loitde -- 经度
    ,dimen -- 维度
    ,teller_id -- 柜员编号
    ,teller_belong_org_id -- 柜员所属机构编号
    ,tran_req_tm -- 交易请求时间
    ,tran_resp_tm -- 交易响应时间
    ,tran_order_no -- 交易订单号
    ,chain_way_track_no -- 链路跟踪号
    ,sys_flow_num -- 系统流水号
    ,chn_id -- 渠道编号
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
from ${iml_schema}.evt_priv_onl_bank_tran_flow
where 0=1;


-- it is no need to check when this segment SQL was return faied
whenever sqlerror exit sql.sqlcode;
-- 3.1 insert data to tm table
-- osbs_ops_trade_flow-1
insert into ${iml_schema}.evt_priv_onl_bank_tran_flow_osbsi1_tm(
    evt_id -- 事件编号
    ,lp_id -- 法人编号
    ,main_flow_num -- 主流水号
    ,tran_flow_num -- 交易流水号
    ,ova_flow_num -- 全局流水号
    ,whole_unify_cust_id -- 全行统一客户编号
    ,cust_name -- 客户名称
    ,user_seq_num -- 用户顺序号
    ,tran_code -- 交易码
    ,bus_gen_cd -- 业务大类代码
    ,bus_type_cd -- 业务类型代码
    ,tran_dt -- 交易日期
    ,tran_tm -- 交易时间
    ,tran_acct_num -- 交易账号
    ,curr_cd -- 币种代码
    ,tran_amt -- 交易金额
    ,comm_fee -- 手续费
    ,sys_id -- 系统编号
    ,sorc_sys_id -- 源系统编号
    ,four_chn_cd -- 四位渠道代码
    ,tran_status_cd -- 交易状态代码
    ,tran_err_cd -- 交易错误代码
    ,tran_err_descb -- 交易错误描述
    ,core_tran_flow_num -- 核心交易流水号
    ,core_tran_dt -- 核心交易日期
    ,visit_flow_num -- 访问流水号
    ,rela_flow_num -- 关联流水号
    ,proc_server_ip -- 处理服务器IP
    ,logon_node_id -- 登陆节点编号
    ,substep_tran_scrt_key -- 分步交易密钥
    ,tran_comnt -- 交易说明
    ,tran_type_cd -- 交易类型代码
    ,func_menu_id -- 功能菜单编号
    ,client_ip -- 客户端IP
    ,client_mac -- 客户端MAC
    ,equip_id -- 设备编号
    ,equip_brand_name -- 设备品牌名称
    ,equip_model -- 设备型号
    ,brow_type_cd -- 浏览器类型代码
    ,brow_edit_num -- 浏览器版本号
    ,loitde -- 经度
    ,dimen -- 维度
    ,teller_id -- 柜员编号
    ,teller_belong_org_id -- 柜员所属机构编号
    ,tran_req_tm -- 交易请求时间
    ,tran_resp_tm -- 交易响应时间
    ,tran_order_no -- 交易订单号
    ,chain_way_track_no -- 链路跟踪号
    ,sys_flow_num -- 系统流水号
    ,chn_id -- 渠道编号
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
)
select
    '102053'||P1.OTF_TRADE_FLOWNO||P1.OTF_TRAN_SEQNO -- 事件编号
    ,'9999' -- 法人编号
    ,P1.OTF_TRADE_FLOWNO -- 主流水号
    ,P1.OTF_TRAN_SEQNO -- 交易流水号
    ,P1.OTF_GLOBAL_SEQNO -- 全局流水号
    ,P1.OTF_ECIFNO -- 全行统一客户编号
    ,P1.OTF_ECIFNAME -- 客户名称
    ,P1.OTF_USERNO -- 用户顺序号
    ,P1.OTF_TRANSCODE -- 交易码
    ,P1.OTF_TRANSCATEGORY -- 业务大类代码
    ,P1.OTF_TRANSTYPE -- 业务类型代码
    ,${iml_schema}.dateformat_max(otf_transdate) -- 交易日期
    ,case when trim(otf_transtime) is null then '000000'
else (
case when length(otf_transtime)=6 then otf_transtime 
else substr(otf_transtime,9,6) end
) end -- 交易时间
    ,P1.OTF_ACCNO -- 交易账号
    ,CASE WHEN R1.TARGET_CD_VAL IS NOT NULL THEN R1.TARGET_CD_VAL ELSE '@'||P1.OTF_CURRENCY END -- 币种代码
    ,P1.OTF_AMONUT -- 交易金额
    ,P1.OTF_FEE -- 手续费
    ,P1.OTF_SYSID -- 系统编号
    ,P1.OTF_SOURCESYSID -- 源系统编号
    ,P1.OTF_CHANNELCODE -- 四位渠道代码
    ,P1.OTF_STATE -- 交易状态代码
    ,P1.OTF_RETURNCODE -- 交易错误代码
    ,P1.OTF_RETURNMSG -- 交易错误描述
    ,P1.OTF_HOSTFLOWNO -- 核心交易流水号
    ,${iml_schema}.dateformat_max(otf_host_returntime) -- 核心交易日期
    ,P1.OTF_ACCESSFLOWNO -- 访问流水号
    ,P1.OTF_RELFLOWNO -- 关联流水号
    ,P1.OTF_SERVERIP -- 处理服务器IP
    ,P1.OTF_SESSIONID -- 登陆节点编号
    ,P1.OTF_ACCESSTOKEN -- 分步交易密钥
    ,P1.OTF_TRADE_ABSTRACT -- 交易说明
    ,P1.OTF_TRSTYPE -- 交易类型代码
    ,P1.OTF_MENUID -- 功能菜单编号
    ,P1.OTF_CLIENTIP -- 客户端IP
    ,P1.OTF_CLIENTMAC -- 客户端MAC
    ,P1.OTF_DEVICENO -- 设备编号
    ,P1.OTF_BRAND -- 设备品牌名称
    ,P1.OTF_MODEL -- 设备型号
    ,P1.OTF_BROWSERTYPE -- 浏览器类型代码
    ,P1.OTF_BROWSERVERSION -- 浏览器版本号
    ,P1.OTF_LONGITUDE -- 经度
    ,P1.OTF_LATITUDE -- 维度
    ,P1.OTF_TELLERID -- 柜员编号
    ,P1.OTF_TELLERDEPTID -- 柜员所属机构编号
    ,to_timestamp(case when trim(otf_reqtime) is not null then 
substr(otf_reqtime,1,8)||' '||substr(otf_reqtime,9,2)||':'||substr(otf_reqtime,11,2)||':'||substr(otf_reqtime,13,2) else '20991231 00:00:00' end
,'yyyymmdd hh24:mi:ss.ff6') -- 交易请求时间
    ,to_timestamp(case when trim(otf_resptime) is not null then 
substr(otf_resptime,1,8)||' '||nvl(substr(otf_resptime,9,2),'00')||':'||nvl(substr(otf_resptime,11,2),'00')||':'||nvl(substr(otf_resptime,13,2),'00') else '20991231 00:00:00' end
,'yyyymmdd hh24:mi:ss.ff6') -- 交易响应时间
    ,P1.TX_SEQ_NUM -- 交易订单号
    ,P1.CHAIN_WAY_TRACK_NO -- 链路跟踪号
    ,P1.BIZ_SEQ_NUM -- 系统流水号
    ,nvl(trim(P1.OTF_CHANNELCODE),'-') -- 渠道编号
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,'osbs_ops_trade_flow' -- 源表名称
    ,'osbsi1' -- 任务编码
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间戳
from ${iol_schema}.osbs_ops_trade_flow p1
    left join ${iml_schema}.ref_pub_cd_map r1 on P1.OTF_CURRENCY = R1.SRC_CODE_VAL
        AND R1.SORC_SYS_CD= 'OSBS'
        AND R1.SRC_TAB_EN_NAME= 'OSBS_OPS_TRADE_FLOW'
        AND R1.SRC_FIELD_EN_NAME= 'OTF_CURRENCY'
        AND R1.TARGET_TAB_EN_NAME= 'EVT_PRIV_ONL_BANK_TRAN_FLOW'
        AND R1.TARGET_TAB_FIELD_EN_NAME= 'CURR_CD'
where  1 = 1 
    and p1.otf_transdate = '${batch_date}'
;
commit;



-- 3.2 truncate target table batch_date partition
alter table ${iml_schema}.evt_priv_onl_bank_tran_flow truncate subpartition p_osbsi1_${batch_date} reuse storage;


-- 3.3 exchage tm table and target table
alter table ${iml_schema}.evt_priv_onl_bank_tran_flow exchange subpartition p_osbsi1_${batch_date} with table ${iml_schema}.evt_priv_onl_bank_tran_flow_osbsi1_tm;

-- 4.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iml_schema}.evt_priv_onl_bank_tran_flow to ${iml_schema};

-- 4.2 drop tm table
drop table ${iml_schema}.evt_priv_onl_bank_tran_flow_osbsi1_tm purge;

-- 5 gater table status
exec dbms_stats.gather_table_stats(ownname => '${iml_schema}',tabname => 'evt_priv_onl_bank_tran_flow', partname => 'p_osbsi1_${batch_date}', ESTIMATE_PERCENT=>10, method_opt=>'for all columns size 1',no_invalidate=>false, force=>true, granularity => 'SUBPARTITION', degree => 8, cascade => true);