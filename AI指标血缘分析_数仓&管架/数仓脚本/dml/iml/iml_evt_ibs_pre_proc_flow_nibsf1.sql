/*
Purpose:    整合模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iml_evt_ibs_pre_proc_flow_nibsf1
CreateDate: 20180515
Logs:
    zjj 2018-05-15 新建表本
*/

set timing on

-- 1 alter parallel
alter session force parallel query parallel 4;
alter session force parallel dml parallel 4;
-- alter session force parallel ddl parallel 1;

-- 2.1 create backup table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
alter table ${iml_schema}.evt_ibs_pre_proc_flow add partition p_nibsf1 values ('nibsf1')(
        subpartition p_nibsf1_19000101 values (to_date('19000101','yyyymmdd'))
        ,subpartition p_nibsf1_20991231 values (to_date('20991231','yyyymmdd'))
    )
;

-- if backup table is exists, mean script if failed on last time
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
create table ${iml_schema}.evt_ibs_pre_proc_flow_nibsf1_bk nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.evt_ibs_pre_proc_flow partition for ('nibsf1')
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd')
;

-- 2.2 drop temp table
whenever sqlerror continue none ;
-- it is no need to check when this segment SQL was return faied
drop table ${iml_schema}.evt_ibs_pre_proc_flow_nibsf1_tm purge;
drop table ${iml_schema}.evt_ibs_pre_proc_flow_nibsf1_op purge;
drop table ${iml_schema}.evt_ibs_pre_proc_flow_nibsf1_cl purge;

-- 2.3 create temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.evt_ibs_pre_proc_flow_nibsf1_tm nologging
compress ${option_switch} for query high
as select
    evt_id -- 事件编号
    ,lp_id -- 法人编号
    ,pre_proc_id -- 预受理编号
    ,init_pre_proc_id -- 原预受理编号
    ,bus_type_cd -- 业务类型代码
    ,pre_proc_status_cd -- 预受理状态代码
    ,tran_flow_num -- 交易流水号
    ,init_chn_cd -- 发起渠道代码
    ,flow_bank_proc_flow_num -- 流程银行受理流水号
    ,appl_dt -- 申请日期
    ,appl_org_id -- 申请机构编号
    ,acct_id -- 账户编号
    ,acct_name -- 账户名称
    ,cust_id -- 客户编号
    ,cust_name -- 客户名称
    ,cert_type_cd -- 证件类型代码
    ,cert_no -- 证件号码
    ,cert_name -- 证件名称
    ,agent_flg -- 代理标志
    ,agent_cert_type_cd -- 代理人证件类型代码
    ,agent_cert_no -- 代理人证件号码
    ,agent_cert_name -- 代理人证件名称
    ,agent_cont_mode_cd -- 代理人联系方式代码
    ,mobile_no -- 手机号码
    ,precon_id -- 预约ID
    ,wdraw_usage_and_reason -- 提现理由代码
    ,other_usage -- 其他用途
    ,par_type_comb -- 券别组合
    ,par_type_amt_comb -- 券别金额组合
    ,curr_cd -- 币种代码
    ,wdraw_lmt_comb -- 提现金额组合
    ,tran_type_cd -- 交易类型代码
    ,card_status_cd -- 卡状态代码
    ,bus_content_descb -- 业务内容描述
    ,remark -- 备注
    ,create_tm -- 创建时间
    ,create_teller_id -- 创建柜员编号
    ,to_date('${batch_date}', 'yyyymmdd') as etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
from ${iml_schema}.evt_ibs_pre_proc_flow partition for ('nibsf1')
where 0=1
;

create table ${iml_schema}.evt_ibs_pre_proc_flow_nibsf1_op nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.evt_ibs_pre_proc_flow partition for ('nibsf1') where 0=1;

create table ${iml_schema}.evt_ibs_pre_proc_flow_nibsf1_cl nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.evt_ibs_pre_proc_flow partition for ('nibsf1') where 0=1;

-- 3.1 get new data into table
-- nibs_ibs_acp_acceptmain_log-1
insert into ${iml_schema}.evt_ibs_pre_proc_flow_nibsf1_tm(
    evt_id -- 事件编号
    ,lp_id -- 法人编号
    ,pre_proc_id -- 预受理编号
    ,init_pre_proc_id -- 原预受理编号
    ,bus_type_cd -- 业务类型代码
    ,pre_proc_status_cd -- 预受理状态代码
    ,tran_flow_num -- 交易流水号
    ,init_chn_cd -- 发起渠道代码
    ,flow_bank_proc_flow_num -- 流程银行受理流水号
    ,appl_dt -- 申请日期
    ,appl_org_id -- 申请机构编号
    ,acct_id -- 账户编号
    ,acct_name -- 账户名称
    ,cust_id -- 客户编号
    ,cust_name -- 客户名称
    ,cert_type_cd -- 证件类型代码
    ,cert_no -- 证件号码
    ,cert_name -- 证件名称
    ,agent_flg -- 代理标志
    ,agent_cert_type_cd -- 代理人证件类型代码
    ,agent_cert_no -- 代理人证件号码
    ,agent_cert_name -- 代理人证件名称
    ,agent_cont_mode_cd -- 代理人联系方式代码
    ,mobile_no -- 手机号码
    ,precon_id -- 预约ID
    ,wdraw_usage_and_reason -- 提现理由代码
    ,other_usage -- 其他用途
    ,par_type_comb -- 券别组合
    ,par_type_amt_comb -- 券别金额组合
    ,curr_cd -- 币种代码
    ,wdraw_lmt_comb -- 提现金额组合
    ,tran_type_cd -- 交易类型代码
    ,card_status_cd -- 卡状态代码
    ,bus_content_descb -- 业务内容描述
    ,remark -- 备注
    ,create_tm -- 创建时间
    ,create_teller_id -- 创建柜员编号
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
)
select
    '101074'||P1.TRADESERNO -- 事件编号
    ,'9999' -- 法人编号
    ,P1.TRADESERNO -- 预受理编号
    ,P1.OLDTRADESERNO -- 原预受理编号
    ,P1.BIZTYPE -- 业务类型代码
    ,P1.STATUS -- 预受理状态代码
    ,P1.BUSISERNO -- 交易流水号
    ,P1.CHANNELCODE -- 发起渠道代码
    ,P1.REFTRADESERNO -- 流程银行受理流水号
    ,${iml_schema}.dateformat_min(P1.APPLYDATE) -- 申请日期
    ,P1.APPLYBRNO -- 申请机构编号
    ,P1.ACCTNO -- 账户编号
    ,P1.ACCTNAME -- 账户名称
    ,P1.CUSTNO -- 客户编号
    ,P1.CUSTNAME -- 客户名称
    ,nvl(trim(P1.IDTYPE),'0000') -- 证件类型代码
    ,P1.IDNO -- 证件号码
    ,P1.IDNAME -- 证件名称
    ,P1.IS_PORXY -- 代理标志
    ,P1.AGENTIDTYPE -- 代理人证件类型代码
    ,P1.AGENTIDNO -- 代理人证件号码
    ,P1.AGENTIDNAME -- 代理人证件名称
    ,P1.AGENTPHONE -- 代理人联系方式代码
    ,P1.PHONE -- 手机号码
    ,P1.RESERV_ID -- 预约ID
    ,nvl(trim(P1.APPLY_REMARK),'99') -- 提现理由代码
    ,P1.OTHER_REMARK -- 其他用途
    ,P1.VOUCHERS -- 券别组合
    ,P1.VOUCHERS_AMT -- 券别金额组合
    ,P1.APPLY_CCY -- 币种代码
    ,P1.APPLY_AMT -- 提现金额组合
    ,nvl(trim(P1.APPLY_TYPE),'-')  -- 交易类型代码
    ,P1.CARDSTATUS -- 卡状态代码
    ,P2.CONTENT -- 业务内容描述
    ,P1.REMARK -- 备注
    ,timeformat_min(P1.CREATEDATE||' '||P1.CREATETIME) -- 创建时间
    ,P1.CREATEBY -- 创建柜员编号
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,'nibs_ibs_acp_acceptmain_log' -- 源表名称
    ,'nibsf1' -- 任务编码
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间戳
from ${iol_schema}.nibs_ibs_acp_acceptmain_log p1
    left join ${iol_schema}.nibs_ibs_acp_attachment_info p2 on P1.TRADESERNO=P2.TRADESERNO
AND P2.ETL_DT=TO_DATE('${batch_date}','YYYYMMDD')
where p1.start_dt <= to_date('${batch_date}','yyyymmdd') and p1.end_dt > to_date('${batch_date}','yyyymmdd') 
;
commit;


commit;

whenever sqlerror exit sql.sqlcode;
declare
cnt integer;
begin
  for cur in (select 1 from dual) loop
  	select count(1) into cnt from (select 1 from ${iml_schema}.evt_ibs_pre_proc_flow_nibsf1_tm 
  	                                group by 
  	                                        evt_id
  	                                        ,lp_id
  	                                        ,pre_proc_id
  	                               having count(1) > 1);
    if cnt = 0 
      then
        continue;
      else
        raise_application_error(-20001,'primary key is duplication');
    end if;
  end loop;
end;
/


-- 3.2 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iml_schema}.evt_ibs_pre_proc_flow_nibsf1_cl(
            evt_id -- 事件编号
    ,lp_id -- 法人编号
    ,pre_proc_id -- 预受理编号
    ,init_pre_proc_id -- 原预受理编号
    ,bus_type_cd -- 业务类型代码
    ,pre_proc_status_cd -- 预受理状态代码
    ,tran_flow_num -- 交易流水号
    ,init_chn_cd -- 发起渠道代码
    ,flow_bank_proc_flow_num -- 流程银行受理流水号
    ,appl_dt -- 申请日期
    ,appl_org_id -- 申请机构编号
    ,acct_id -- 账户编号
    ,acct_name -- 账户名称
    ,cust_id -- 客户编号
    ,cust_name -- 客户名称
    ,cert_type_cd -- 证件类型代码
    ,cert_no -- 证件号码
    ,cert_name -- 证件名称
    ,agent_flg -- 代理标志
    ,agent_cert_type_cd -- 代理人证件类型代码
    ,agent_cert_no -- 代理人证件号码
    ,agent_cert_name -- 代理人证件名称
    ,agent_cont_mode_cd -- 代理人联系方式代码
    ,mobile_no -- 手机号码
    ,precon_id -- 预约ID
    ,wdraw_usage_and_reason -- 提现理由代码
    ,other_usage -- 其他用途
    ,par_type_comb -- 券别组合
    ,par_type_amt_comb -- 券别金额组合
    ,curr_cd -- 币种代码
    ,wdraw_lmt_comb -- 提现金额组合
    ,tran_type_cd -- 交易类型代码
    ,card_status_cd -- 卡状态代码
    ,bus_content_descb -- 业务内容描述
    ,remark -- 备注
    ,create_tm -- 创建时间
    ,create_teller_id -- 创建柜员编号
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iml_schema}.evt_ibs_pre_proc_flow_nibsf1_op(
            evt_id -- 事件编号
    ,lp_id -- 法人编号
    ,pre_proc_id -- 预受理编号
    ,init_pre_proc_id -- 原预受理编号
    ,bus_type_cd -- 业务类型代码
    ,pre_proc_status_cd -- 预受理状态代码
    ,tran_flow_num -- 交易流水号
    ,init_chn_cd -- 发起渠道代码
    ,flow_bank_proc_flow_num -- 流程银行受理流水号
    ,appl_dt -- 申请日期
    ,appl_org_id -- 申请机构编号
    ,acct_id -- 账户编号
    ,acct_name -- 账户名称
    ,cust_id -- 客户编号
    ,cust_name -- 客户名称
    ,cert_type_cd -- 证件类型代码
    ,cert_no -- 证件号码
    ,cert_name -- 证件名称
    ,agent_flg -- 代理标志
    ,agent_cert_type_cd -- 代理人证件类型代码
    ,agent_cert_no -- 代理人证件号码
    ,agent_cert_name -- 代理人证件名称
    ,agent_cont_mode_cd -- 代理人联系方式代码
    ,mobile_no -- 手机号码
    ,precon_id -- 预约ID
    ,wdraw_usage_and_reason -- 提现理由代码
    ,other_usage -- 其他用途
    ,par_type_comb -- 券别组合
    ,par_type_amt_comb -- 券别金额组合
    ,curr_cd -- 币种代码
    ,wdraw_lmt_comb -- 提现金额组合
    ,tran_type_cd -- 交易类型代码
    ,card_status_cd -- 卡状态代码
    ,bus_content_descb -- 业务内容描述
    ,remark -- 备注
    ,create_tm -- 创建时间
    ,create_teller_id -- 创建柜员编号
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.evt_id, o.evt_id) as evt_id -- 事件编号
    ,nvl(n.lp_id, o.lp_id) as lp_id -- 法人编号
    ,nvl(n.pre_proc_id, o.pre_proc_id) as pre_proc_id -- 预受理编号
    ,nvl(n.init_pre_proc_id, o.init_pre_proc_id) as init_pre_proc_id -- 原预受理编号
    ,nvl(n.bus_type_cd, o.bus_type_cd) as bus_type_cd -- 业务类型代码
    ,nvl(n.pre_proc_status_cd, o.pre_proc_status_cd) as pre_proc_status_cd -- 预受理状态代码
    ,nvl(n.tran_flow_num, o.tran_flow_num) as tran_flow_num -- 交易流水号
    ,nvl(n.init_chn_cd, o.init_chn_cd) as init_chn_cd -- 发起渠道代码
    ,nvl(n.flow_bank_proc_flow_num, o.flow_bank_proc_flow_num) as flow_bank_proc_flow_num -- 流程银行受理流水号
    ,nvl(n.appl_dt, o.appl_dt) as appl_dt -- 申请日期
    ,nvl(n.appl_org_id, o.appl_org_id) as appl_org_id -- 申请机构编号
    ,nvl(n.acct_id, o.acct_id) as acct_id -- 账户编号
    ,nvl(n.acct_name, o.acct_name) as acct_name -- 账户名称
    ,nvl(n.cust_id, o.cust_id) as cust_id -- 客户编号
    ,nvl(n.cust_name, o.cust_name) as cust_name -- 客户名称
    ,nvl(n.cert_type_cd, o.cert_type_cd) as cert_type_cd -- 证件类型代码
    ,nvl(n.cert_no, o.cert_no) as cert_no -- 证件号码
    ,nvl(n.cert_name, o.cert_name) as cert_name -- 证件名称
    ,nvl(n.agent_flg, o.agent_flg) as agent_flg -- 代理标志
    ,nvl(n.agent_cert_type_cd, o.agent_cert_type_cd) as agent_cert_type_cd -- 代理人证件类型代码
    ,nvl(n.agent_cert_no, o.agent_cert_no) as agent_cert_no -- 代理人证件号码
    ,nvl(n.agent_cert_name, o.agent_cert_name) as agent_cert_name -- 代理人证件名称
    ,nvl(n.agent_cont_mode_cd, o.agent_cont_mode_cd) as agent_cont_mode_cd -- 代理人联系方式代码
    ,nvl(n.mobile_no, o.mobile_no) as mobile_no -- 手机号码
    ,nvl(n.precon_id, o.precon_id) as precon_id -- 预约ID
    ,nvl(n.wdraw_usage_and_reason, o.wdraw_usage_and_reason) as wdraw_usage_and_reason -- 提现理由代码
    ,nvl(n.other_usage, o.other_usage) as other_usage -- 其他用途
    ,nvl(n.par_type_comb, o.par_type_comb) as par_type_comb -- 券别组合
    ,nvl(n.par_type_amt_comb, o.par_type_amt_comb) as par_type_amt_comb -- 券别金额组合
    ,nvl(n.curr_cd, o.curr_cd) as curr_cd -- 币种代码
    ,nvl(n.wdraw_lmt_comb, o.wdraw_lmt_comb) as wdraw_lmt_comb -- 提现金额组合
    ,nvl(n.tran_type_cd, o.tran_type_cd) as tran_type_cd -- 交易类型代码
    ,nvl(n.card_status_cd, o.card_status_cd) as card_status_cd -- 卡状态代码
    ,nvl(n.bus_content_descb, o.bus_content_descb) as bus_content_descb -- 业务内容描述
    ,nvl(n.remark, o.remark) as remark -- 备注
    ,nvl(n.create_tm, o.create_tm) as create_tm -- 创建时间
    ,nvl(n.create_teller_id, o.create_teller_id) as create_teller_id -- 创建柜员编号
    ,case when
            n.evt_id is null
            and n.lp_id is null
            and n.pre_proc_id is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.evt_id is null
            and n.lp_id is null
            and n.pre_proc_id is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.evt_id is null
            and n.lp_id is null
            and n.pre_proc_id is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,nvl(n.src_table_name, o.src_table_name) as src_table_name -- 源表名称
    ,nvl(n.job_cd, o.job_cd) as job_cd -- 任务编码
    ,nvl(n.etl_timestamp, o.etl_timestamp) as etl_timestamp -- ETL处理时间戳
from ${iml_schema}.evt_ibs_pre_proc_flow_nibsf1_tm n
    full join (select * from ${iml_schema}.evt_ibs_pre_proc_flow_nibsf1_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
        on
            o.evt_id = n.evt_id
            and o.lp_id = n.lp_id
            and o.pre_proc_id = n.pre_proc_id
where (
        o.evt_id is null
        and o.lp_id is null
        and o.pre_proc_id is null
    )
    or (
        n.evt_id is null
        and n.lp_id is null
        and n.pre_proc_id is null
    )
    or (
        o.init_pre_proc_id <> n.init_pre_proc_id
        or o.bus_type_cd <> n.bus_type_cd
        or o.pre_proc_status_cd <> n.pre_proc_status_cd
        or o.tran_flow_num <> n.tran_flow_num
        or o.init_chn_cd <> n.init_chn_cd
        or o.flow_bank_proc_flow_num <> n.flow_bank_proc_flow_num
        or o.appl_dt <> n.appl_dt
        or o.appl_org_id <> n.appl_org_id
        or o.acct_id <> n.acct_id
        or o.acct_name <> n.acct_name
        or o.cust_id <> n.cust_id
        or o.cust_name <> n.cust_name
        or o.cert_type_cd <> n.cert_type_cd
        or o.cert_no <> n.cert_no
        or o.cert_name <> n.cert_name
        or o.agent_flg <> n.agent_flg
        or o.agent_cert_type_cd <> n.agent_cert_type_cd
        or o.agent_cert_no <> n.agent_cert_no
        or o.agent_cert_name <> n.agent_cert_name
        or o.agent_cont_mode_cd <> n.agent_cont_mode_cd
        or o.mobile_no <> n.mobile_no
        or o.precon_id <> n.precon_id
        or o.wdraw_usage_and_reason <> n.wdraw_usage_and_reason
        or o.other_usage <> n.other_usage
        or o.par_type_comb <> n.par_type_comb
        or o.par_type_amt_comb <> n.par_type_amt_comb
        or o.curr_cd <> n.curr_cd
        or o.wdraw_lmt_comb <> n.wdraw_lmt_comb
        or o.tran_type_cd <> n.tran_type_cd
        or o.card_status_cd <> n.card_status_cd
        or o.bus_content_descb <> n.bus_content_descb
        or o.remark <> n.remark
        or o.create_tm <> n.create_tm
        or o.create_teller_id <> n.create_teller_id
    )
;
commit;

-- 3.3 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iml_schema}.evt_ibs_pre_proc_flow_nibsf1_cl(
            evt_id -- 事件编号
    ,lp_id -- 法人编号
    ,pre_proc_id -- 预受理编号
    ,init_pre_proc_id -- 原预受理编号
    ,bus_type_cd -- 业务类型代码
    ,pre_proc_status_cd -- 预受理状态代码
    ,tran_flow_num -- 交易流水号
    ,init_chn_cd -- 发起渠道代码
    ,flow_bank_proc_flow_num -- 流程银行受理流水号
    ,appl_dt -- 申请日期
    ,appl_org_id -- 申请机构编号
    ,acct_id -- 账户编号
    ,acct_name -- 账户名称
    ,cust_id -- 客户编号
    ,cust_name -- 客户名称
    ,cert_type_cd -- 证件类型代码
    ,cert_no -- 证件号码
    ,cert_name -- 证件名称
    ,agent_flg -- 代理标志
    ,agent_cert_type_cd -- 代理人证件类型代码
    ,agent_cert_no -- 代理人证件号码
    ,agent_cert_name -- 代理人证件名称
    ,agent_cont_mode_cd -- 代理人联系方式代码
    ,mobile_no -- 手机号码
    ,precon_id -- 预约ID
    ,wdraw_usage_and_reason -- 提现理由代码
    ,other_usage -- 其他用途
    ,par_type_comb -- 券别组合
    ,par_type_amt_comb -- 券别金额组合
    ,curr_cd -- 币种代码
    ,wdraw_lmt_comb -- 提现金额组合
    ,tran_type_cd -- 交易类型代码
    ,card_status_cd -- 卡状态代码
    ,bus_content_descb -- 业务内容描述
    ,remark -- 备注
    ,create_tm -- 创建时间
    ,create_teller_id -- 创建柜员编号
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iml_schema}.evt_ibs_pre_proc_flow_nibsf1_op(
            evt_id -- 事件编号
    ,lp_id -- 法人编号
    ,pre_proc_id -- 预受理编号
    ,init_pre_proc_id -- 原预受理编号
    ,bus_type_cd -- 业务类型代码
    ,pre_proc_status_cd -- 预受理状态代码
    ,tran_flow_num -- 交易流水号
    ,init_chn_cd -- 发起渠道代码
    ,flow_bank_proc_flow_num -- 流程银行受理流水号
    ,appl_dt -- 申请日期
    ,appl_org_id -- 申请机构编号
    ,acct_id -- 账户编号
    ,acct_name -- 账户名称
    ,cust_id -- 客户编号
    ,cust_name -- 客户名称
    ,cert_type_cd -- 证件类型代码
    ,cert_no -- 证件号码
    ,cert_name -- 证件名称
    ,agent_flg -- 代理标志
    ,agent_cert_type_cd -- 代理人证件类型代码
    ,agent_cert_no -- 代理人证件号码
    ,agent_cert_name -- 代理人证件名称
    ,agent_cont_mode_cd -- 代理人联系方式代码
    ,mobile_no -- 手机号码
    ,precon_id -- 预约ID
    ,wdraw_usage_and_reason -- 提现理由代码
    ,other_usage -- 其他用途
    ,par_type_comb -- 券别组合
    ,par_type_amt_comb -- 券别金额组合
    ,curr_cd -- 币种代码
    ,wdraw_lmt_comb -- 提现金额组合
    ,tran_type_cd -- 交易类型代码
    ,card_status_cd -- 卡状态代码
    ,bus_content_descb -- 业务内容描述
    ,remark -- 备注
    ,create_tm -- 创建时间
    ,create_teller_id -- 创建柜员编号
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.evt_id -- 事件编号
    ,o.lp_id -- 法人编号
    ,o.pre_proc_id -- 预受理编号
    ,o.init_pre_proc_id -- 原预受理编号
    ,o.bus_type_cd -- 业务类型代码
    ,o.pre_proc_status_cd -- 预受理状态代码
    ,o.tran_flow_num -- 交易流水号
    ,o.init_chn_cd -- 发起渠道代码
    ,o.flow_bank_proc_flow_num -- 流程银行受理流水号
    ,o.appl_dt -- 申请日期
    ,o.appl_org_id -- 申请机构编号
    ,o.acct_id -- 账户编号
    ,o.acct_name -- 账户名称
    ,o.cust_id -- 客户编号
    ,o.cust_name -- 客户名称
    ,o.cert_type_cd -- 证件类型代码
    ,o.cert_no -- 证件号码
    ,o.cert_name -- 证件名称
    ,o.agent_flg -- 代理标志
    ,o.agent_cert_type_cd -- 代理人证件类型代码
    ,o.agent_cert_no -- 代理人证件号码
    ,o.agent_cert_name -- 代理人证件名称
    ,o.agent_cont_mode_cd -- 代理人联系方式代码
    ,o.mobile_no -- 手机号码
    ,o.precon_id -- 预约ID
    ,o.wdraw_usage_and_reason -- 提现理由代码
    ,o.other_usage -- 其他用途
    ,o.par_type_comb -- 券别组合
    ,o.par_type_amt_comb -- 券别金额组合
    ,o.curr_cd -- 币种代码
    ,o.wdraw_lmt_comb -- 提现金额组合
    ,o.tran_type_cd -- 交易类型代码
    ,o.card_status_cd -- 卡状态代码
    ,o.bus_content_descb -- 业务内容描述
    ,o.remark -- 备注
    ,o.create_tm -- 创建时间
    ,o.create_teller_id -- 创建柜员编号
    ,o.start_dt -- 开始时间
    ,case when n.start_dt is not null then to_date('${batch_date}', 'yyyymmdd')
          when o.end_dt >= to_date('${batch_date}','yyyymmdd') then to_date('20991231','yyyymmdd')
          else o.end_dt
     end as end_dt -- 结束时间
    , case when n.start_dt is not null
          then 'I'
          when o.end_dt >= to_date('${batch_date}','yyyymmdd')
          then 'I'
          else o.id_mark
     end as id_mark  -- 增删标志 
    ,o.src_table_name -- 源表名称
    ,o.job_cd -- 任务编码
    ,o.etl_timestamp -- ETL处理时间戳
from ${iml_schema}.evt_ibs_pre_proc_flow_nibsf1_bk o
    left join ${iml_schema}.evt_ibs_pre_proc_flow_nibsf1_op n
        on
            o.evt_id = n.evt_id
            and o.lp_id = n.lp_id
            and o.pre_proc_id = n.pre_proc_id
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iml_schema}.evt_ibs_pre_proc_flow_nibsf1_cl d
        on
            o.evt_id = d.evt_id
            and o.lp_id = d.lp_id
            and o.pre_proc_id = d.pre_proc_id
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;
-- 4.1 truncate target table
--truncate table ${iml_schema}.evt_ibs_pre_proc_flow;
--alter table ${iml_schema}.evt_ibs_pre_proc_flow truncate partition for ('nibsf1') reuse storage;

-- 4.2 rebuild partition
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
declare
v_sql varchar2(100);
begin
for cur in (select subpartition_name 
              from all_tab_subpartitions 
             where table_owner=upper('${iml_schema}') 
               and table_name=upper('evt_ibs_pre_proc_flow') 
               and substr(subpartition_name,1,8)=upper('p_nibsf1')
               and substr(subpartition_name,10) >= '${batch_date}' 
               and substr(subpartition_name,10) < '20991231') loop
    v_sql := 'alter table ${iml_schema}.evt_ibs_pre_proc_flow drop subpartition ' || cur.subpartition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/

alter table ${iml_schema}.evt_ibs_pre_proc_flow modify partition p_nibsf1 
add subpartition p_nibsf1_${batch_date} values(to_date('${batch_date}','YYYYMMDD')) ;

-- 4.3 exchange partition
alter table ${iml_schema}.evt_ibs_pre_proc_flow exchange subpartition p_nibsf1_${batch_date} with table ${iml_schema}.evt_ibs_pre_proc_flow_nibsf1_cl;
alter table ${iml_schema}.evt_ibs_pre_proc_flow exchange subpartition p_nibsf1_20991231 with table ${iml_schema}.evt_ibs_pre_proc_flow_nibsf1_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iml_schema}.evt_ibs_pre_proc_flow to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iml_schema}.evt_ibs_pre_proc_flow_nibsf1_tm purge;
drop table ${iml_schema}.evt_ibs_pre_proc_flow_nibsf1_op purge;
drop table ${iml_schema}.evt_ibs_pre_proc_flow_nibsf1_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iml_schema}.evt_ibs_pre_proc_flow_nibsf1_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iml_schema}',tabname => 'evt_ibs_pre_proc_flow', partname => 'p_nibsf1_20991231',ESTIMATE_PERCENT=>10, method_opt=>'for all columns size 1',no_invalidate=>false, force=>true, granularity => 'SUBPARTITION', degree => 8, cascade => true);
