/*
Purpose:    共性加工层-电子渠道交易明细
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py 20230131 icl_cmm_elec_chn_tran_dtl
CreateDate: 20210407
Logs:       20220324 朱觉军	新增字段【网银交易来源代码】
            20220809 曹永茂 1.调整第1-4组的渠道代码转码落标：decode(ctf_channel, 'TBP', '1018', 'TBM', '1024', '1018')
                              -》decode(ctf_channel, 'TBP', '301003', 'TBM', '302005', '301003')
                            2.调整第5-9组的渠道代码取数标准码值：t1.tran_chn_cd -> t1.chn_id
                            3.调整第8组渠道过滤条件
            20220825 李森辉 调整第5组筛选条件及交易日期字段来源，tran_dt -> tran_tm
            20220913 曹永茂 调整第8组筛选条件,保持和生产一致：t1.chn_id -> T1.TRAN_CHN_CD
            20230215 温旺清 调整第1~4组字段【交易时间】的加工口径
            20231229 陈伟峰 调整【渠道代码】的加工口径，不做默认值处理
            20240903 陈伟峰 调整evt_onl_bank_tran_flow表tran_type_code字段取值，不做TRIM处理
            20250408 陈伟峰 调整算法为增删15天
*/

set timing on
-- 0.1 alter parallel
alter session force parallel query parallel 4;
alter session force parallel dml parallel 4;
-- alter session force parallel ddl parallel 1;
/*
-- 1.1 drop timeout partition and add partition
whenever sqlerror continue none;
--alter table ${icl_schema}.cmm_elec_chn_tran_dtl drop partition p_${retain_day};
alter table ${icl_schema}.cmm_elec_chn_tran_dtl add partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

whenever sqlerror continue none ;
drop table ${icl_schema}.cmm_elec_chn_tran_dtl_ex purge;
create table ${icl_schema}.cmm_elec_chn_tran_dtl_ex nologging
compress ${option_switch} for query high
as select * from ${icl_schema}.cmm_elec_chn_tran_dtl where 0=1;
*/

-- 2.2 truncate target table batch_date partition
-- 3.1 get new data into table
set serveroutput on
--set line 200;
declare bat_dt varchar2(10);
    v_p_exists varchar2(10);
    v_sql varchar2(200);
begin    
--dbms_output.put_line('BBB');
for i in 0 .. 14 loop
    bat_dt := to_char(to_date('${batch_date}','yyyymmdd') - i,'yyyymmdd');
    v_sql := 'select count(0) from user_tab_partitions where table_name = upper(''cmm_elec_chn_tran_dtl'') and PARTITION_NAME = ''P_'||bat_dt||''' ';
    --dbms_output.put_line(v_sql);
    execute immediate v_sql into v_p_exists;
    --dbms_output.put_line(v_p_exists);
    -- exists patitions
    if v_p_exists = 1 then 
        v_sql := 'alter table icl.cmm_elec_chn_tran_dtl truncate partition p_'||bat_dt ;
        dbms_output.put_line(v_sql);
        execute immediate v_sql;
    --dbms_output.put_line('BBB');  
    --no exists partitions  
    else 
        v_sql := 'alter table icl.cmm_elec_chn_tran_dtl add partition p_'||bat_dt||' values (to_date('''||bat_dt||''',''yyyymmdd'')) ';
        dbms_output.put_line(v_sql);
        execute immediate v_sql;
        --dbms_output.put_line('AAA');
    end if;
      end loop;
end;
/

whenever sqlerror exit sql.sqlcode;
--第一组（共九组）
insert /*+ append */ into ${icl_schema}.cmm_elec_chn_tran_dtl(
   etl_dt	                     -- 数据日期
   ,lp_id	                     -- 法人编号
   ,tran_flow_num              -- 交易流水号
   ,ova_chn_flow_num           -- 全局渠道流水号
   ,core_tran_flow_num         -- 核心交易流水号
   ,sorc_sys_flow_num          -- 源系统流水号
   ,osb_tran_flow_num          -- osb交易流水号
   ,rela_timing_task_id        -- 关联定时任务编号
   ,chn_cd                     -- 渠道代码
   ,tran_dt                    -- 交易日期
   ,tran_tm                    -- 交易时间
   ,core_tran_dt               -- 核心交易日期
   ,tran_type_code             -- 交易类型编码
   ,tran_status_cd             -- 交易状态代码
   ,tran_return_code           -- 交易返回码
   ,tran_acct_id               -- 交易账户编号
   ,tran_acct_name             -- 交易账户名称
   ,tran_amt                   -- 交易金额
   ,curr_cd                    -- 币种代码
   ,elec_chn_user_id           -- 电子渠道用户编号
   ,cust_id                    -- 客户编号
   ,termn_ip_addr              -- 终端ip地址
   ,tran_comm_fee              -- 交易手续费
   ,termn_mac_addr             -- 终端mac地址
   ,termn_equip_model          -- 终端设备型号
   ,termn_equip_id             -- 终端设备编号
   ,cntpty_acct_id             -- 交易对手账户编号
   ,cntpty_acct_name           -- 交易对手账户名称
   ,cntpty_acct_open_bank_num  -- 交易对手账户开户行号
   ,cntpty_acct_open_bank_name -- 交易对手账户开户行名
   ,cntpty_acct_prov_cd        -- 交易对手账户省份代码
   ,cntpty_acct_city_cd        -- 交易对手账户城市代码
   ,memo_cd                    -- 摘要代码
   ,memo_descb                 -- 摘要描述
   ,tran_batch_no              -- 交易批次号
   ,tran_org_id                -- 交易机构编号
   ,camp_emply_id              -- 营销员工编号
   ,olbk_tran_src_cd           -- 网银交易来源代码
   ,job_cd                     -- 任务代码
   ,etl_timestamp
)
select
   nvl(to_date(substr(trim(t1.cbd_endtime),0,8),'yyyy-mm-dd'),to_date(substr(trim(t1.cbd_transtime),0,8),'yyyy-mm-dd'))      -- 数据日期
   ,'9999'	                                                                                                 -- 法人编号
   ,t1.cbd_batchno || '_' || t1.cbd_seqno                                                                    -- 交易流水号
   ,t3.ctf_src_sendflowno                                                                                    -- 全局渠道流水号
   ,t1.cbd_hostflow                                                                                          -- 核心交易流水号
   ,t3.ctf_parentlogno                                                                                       -- 源系统流水号
   ,''                                                                                                       -- osb交易流水号
   ,t3.ctf_rootlogno                                                                                         -- 关联定时任务编号
   ,decode(t3.ctf_channel, 'TBP', '301003', 'TBM', '302005')                                                 -- 渠道代码
   ,nvl(to_date(substr(trim(t1.cbd_endtime),0,8),'yyyy-mm-dd'),to_date(substr(trim(t1.cbd_transtime),0,8),'yyyy-mm-dd')) -- 交易日期
   ,t1.cbd_transtime                                                                                         -- 交易时间
   ,to_date(trim(t1.cbd_hostdate),'yyyy-mm-dd')                                                              -- 核心交易日期
   ,'BatchTransfer'                                                                                          -- 交易类型编码
   ,decode(trim(t1.cbd_stt),'C','09','D','03','F','01','I','04','J','01','K','01','L','01','M','05','N','01','R','05','S','00','U','01',T1.CBD_STT) -- 交易状态代码
   ,case when trim(t1.cbd_returncode) is null then '0'
         when t1.cbd_returncode = '0' then '0'
         when t1.cbd_returncode = '000000' then '0'
         when t1.cbd_returncode = '000000000000' then '0' ELSE 'F' end                                       -- 交易返回码
   ,t1.cbd_payacc                                                                                            -- 交易账户编号
   ,t1.cbd_payname                                                                                           -- 交易账户名称
   ,t1.cbd_tranamt                                                                                           -- 交易金额
   ,t1.cbd_currency                                                                                          -- 币种代码
   ,t2.bfl_userno                                                                                            -- 电子渠道用户编号
   ,t2.bfl_ecifno                                                                                            -- 客户编号
   ,t3.ctf_customerip                                                                                        -- 终端ip地址
   ,case when t1.cbd_fee is null or  t1.cbd_fee = '' then 0.00 else t1.cbd_fee end                           -- 交易手续费
   ,t3.ctf_clientmac                                                                                         -- 终端mac地址
   ,t3.ctf_clientnunittype                                                                                   -- 终端设备型号
   ,t3.ctf_clientterminateno                                                                                 -- 终端设备编号
   ,t1.cbd_rcvacc                                                                                            -- 交易对手账户编号
   ,decode(sign(length(t1.cbd_rcvname )- 45),1,substr(t1.cbd_rcvname ,0,45),-1, t1.cbd_rcvname)              -- 交易对手账户名称
   ,case when t1.cbd_transcode = 'BankInnerTransfer' then '313586000006' else t1.cbd_unionnode end           -- 交易对手账户开户行号
   ,case when t1.cbd_transcode = 'BankInnerTransfer' then '广东华兴银行' else t1.cbd_payeeuniondeptname end  -- 交易对手账户开户行名
   ,t1.cbd_payeeprovincecode                                                                                 -- 交易对手账户省份代码
   ,t1.cbd_payeecitycode                                                                                     -- 交易对手账户城市代码
   ,'ZZ'                                                                                                     -- 摘要代码
   ,t1.cbd_remark                                                                                            -- 摘要描述
   ,t1.cbd_batchno                                                                                           -- 交易批次号
   ,t4.cif_opendept                                                                                          -- 交易机构编号
   ,''                                                                                                       -- 营销员工编号
   ,'01'                                                                                                     -- 网银交易来源代码 /*1-企业网银批量转账交易 02-企业网银代发工资交易03-企业网银小额批量转账（五万以下）交易04-企业网银交易/*05-个人网上银行交易06-个人网银批量转账交易 07-外服对私服务业务交易08-外服投资理财业务交易09-个人网银鉴权交易	*/
   ,'tbpsf1'                                                                                                 -- 任务代码
   ,to_timestamp('${batch_timestamp}','yyyy-mm-dd hh24:mi:ss.ff6')                                           -- etl处理时间戳
  from ${iol_schema}.tbps_cpr_batch_detail t1
  left join ${iol_schema}.tbps_cpr_batch_flow t2
    on t1.cbd_batchno = t2.bfl_batchno
   and t2.start_dt <= to_date('${batch_date}','yyyymmdd')
   and t2.end_dt > to_date('${batch_date}','yyyymmdd')
  left join ${iol_schema}.tbps_cpr_trade_flow t3
    on t3.ctf_trade_flowno = t1.cbd_trade_flowno
   and t3.start_dt <= to_date('${batch_date}','yyyymmdd')
   and t3.end_dt > to_date('${batch_date}','yyyymmdd')
  left join ${iol_schema}.tbps_cpr_cst_inf T4
    on t2.bfl_ecifno = t4.cif_ecifno
   and trim(t4.cif_stt) = '0'
   and t4.start_dt <= to_date('${batch_date}','yyyymmdd')
   and t4.end_dt > to_date('${batch_date}','yyyymmdd')
 where (t1.cbd_stt) <> 'D'
   and nvl(to_date(substr(trim(t1.cbd_endtime),0,8),'yyyy-mm-dd'),to_date(substr(trim(t1.cbd_transtime),0,8),'yyyy-mm-dd'))>= to_date('${batch_date}','yyyymmdd')-14
   and nvl(to_date(substr(trim(t1.cbd_endtime),0,8),'yyyy-mm-dd'),to_date(substr(trim(t1.cbd_transtime),0,8),'yyyy-mm-dd'))<= to_date('${batch_date}','yyyymmdd')
--   and t1.etl_dt = to_date('${batch_date}','yyyymmdd')    --zhujj 20210702 全量流水表
;
commit;


whenever sqlerror exit sql.sqlcode;
--第二组（共九组）
insert /*+ append */ into ${icl_schema}.cmm_elec_chn_tran_dtl(
   etl_dt	                     -- 数据日期
   ,lp_id	                     -- 法人编号
   ,tran_flow_num              -- 交易流水号
   ,ova_chn_flow_num           -- 全局渠道流水号
   ,core_tran_flow_num         -- 核心交易流水号
   ,sorc_sys_flow_num          -- 源系统流水号
   ,osb_tran_flow_num          -- osb交易流水号
   ,rela_timing_task_id        -- 关联定时任务编号
   ,chn_cd                     -- 渠道代码
   ,tran_dt                    -- 交易日期
   ,tran_tm                    -- 交易时间
   ,core_tran_dt               -- 核心交易日期
   ,tran_type_code             -- 交易类型编码
   ,tran_status_cd             -- 交易状态代码
   ,tran_return_code           -- 交易返回码
   ,tran_acct_id               -- 交易账户编号
   ,tran_acct_name             -- 交易账户名称
   ,tran_amt                   -- 交易金额
   ,curr_cd                    -- 币种代码
   ,elec_chn_user_id           -- 电子渠道用户编号
   ,cust_id                    -- 客户编号
   ,termn_ip_addr              -- 终端ip地址
   ,tran_comm_fee              -- 交易手续费
   ,termn_mac_addr             -- 终端mac地址
   ,termn_equip_model          -- 终端设备型号
   ,termn_equip_id             -- 终端设备编号
   ,cntpty_acct_id             -- 交易对手账户编号
   ,cntpty_acct_name           -- 交易对手账户名称
   ,cntpty_acct_open_bank_num  -- 交易对手账户开户行号
   ,cntpty_acct_open_bank_name -- 交易对手账户开户行名
   ,cntpty_acct_prov_cd        -- 交易对手账户省份代码
   ,cntpty_acct_city_cd        -- 交易对手账户城市代码
   ,memo_cd                    -- 摘要代码
   ,memo_descb                 -- 摘要描述
   ,tran_batch_no              -- 交易批次号
   ,tran_org_id                -- 交易机构编号
   ,camp_emply_id              -- 营销员工编号
   ,olbk_tran_src_cd           -- 网银交易来源代码
   ,job_cd                     -- 任务代码
   ,etl_timestamp
)
select
   to_date(substr(trim(t1.sbd_salarydate),1,8),'YYYYMMDD')	                                                                   -- 数据日期
   ,'9999'	                                                                                               -- 法人编号
   ,(t1.sbd_batchno || '_' || t1.sbd_seqno)                                                                -- 交易流水号
   ,t3.ctf_src_sendflowno                                                                                  -- 全局渠道流水号
   ,t1.sbd_hostjnlno                                                                                       -- 核心交易流水号
   ,t3.ctf_parentlogno                                                                                     -- 源系统流水号
   ,''                                                                                                     -- OSB交易流水号
   ,t3.ctf_rootlogno                                                                                       -- 关联定时任务编号
   ,decode(t3.ctf_channel, 'TBP', '301003', 'TBM', '302005')                                               -- 渠道代码
   ,to_date(substr(trim(t1.sbd_salarydate),0,8),'YYYY-MM-DD')                                              -- 交易日期
   ,t1.sbd_salarytime                                                                                      -- 交易时间
   ,to_date(trim(t1.sbd_hostjnldate),'YYYY-MM-DD')                                                         -- 核心交易日期
   ,case when t2.sbf_batchstyle = '0' then 'SalaryPay' else 'Expenses' end                                 -- 交易类型编码
   ,case when t1.sbd_detailstate in ('2','7') then '01'
         when t1.sbd_detailstate in ('3','4','6','8','S') then '04'
         when t1.sbd_detailstate in ('I','M') then '05'
         when t1.sbd_detailstate in ('J','K') then '07'
         when t1.sbd_detailstate in ('10') then '08'
         when t1.sbd_detailstate in ('5','C') then '09'
         when t1.sbd_detailstate in ('1') then '00'
    end                                                                                                     -- 交易状态代码
   ,case when t1.sbd_detailstate='1'then '0' else 'F' end                                                   -- 交易返回码
   ,t1.sbd_payeracno                                                                                        -- 交易账户编号
   ,t1.sbd_payeracname                                                                                      -- 交易账户名称
   ,t1.sbd_amount                                                                                           -- 交易金额
   ,t1.sbd_currency                                                                                         -- 币种代码
   ,t2.sbf_userno                                                                                           -- 电子渠道用户编号
   ,t2.sbf_ecifno                                                                                           -- 客户编号
   ,t3.ctf_customerip                                                                                       -- 终端ip地址
   ,0                                                                                                       -- 交易手续费
   ,t3.ctf_clientmac                                                                                        -- 终端mac地址
   ,t3.ctf_clientnunittype                                                                                  -- 终端设备型号
   ,t3.ctf_clientterminateno                                                                                -- 终端设备编号
   ,t1.sbd_payeeacno                                                                                        -- 交易对手账户编号
   ,decode(sign(length(t1.sbd_payeeacname )- 45),1,substr(t1.sbd_payeeacname ,0,45),-1, t1.sbd_payeeacname) -- 交易对手账户名称
   ,case when t2.sbf_sysflag = '0' then '313586000006' else t1.sbd_uniondeptid end                          -- 交易对手账户开户行号
   ,case when t2.sbf_sysflag = '0' then '广东华兴银行' else t1.sbd_uniondeptname end                        -- 交易对手账户开户行名
   ,''                                                                                                      -- 交易对手账户省份代码
   ,''                                                                                                      -- 交易对手账户城市代码
   ,'ZZ'                                                                                                    -- 摘要代码
   ,t1.sbd_remark                                                                                           -- 摘要描述
   ,t1.sbd_batchno                                                                                          -- 交易批次号
   ,t4.cif_opendept                                                                                         -- 交易机构编号
   ,''                                                                                                      -- 营销员工编号
   ,'02'                                                                                                    -- 网银交易来源代码
   ,'tbpsf2'                                                                                                -- 任务代码
   ,to_timestamp('${batch_timestamp}','yyyy-mm-dd hh24:mi:ss.ff6')                                          -- etl处理时间戳
  from ${iol_schema}.tbps_cpr_salary_batch_detail t1
  left join ${iol_schema}.tbps_cpr_salary_batch_flow t2
    on t1.sbd_batchno = t2.sbf_batchno
   and t2.start_dt <= to_date('${batch_date}','yyyymmdd')
   and t2.end_dt > to_date('${batch_date}','yyyymmdd')
  left join ${iol_schema}.tbps_cpr_trade_flow t3
    on t3.ctf_trade_flowno=t2.sbf_trade_flowno
   and t3.start_dt <= to_date('${batch_date}','yyyymmdd')
   and t3.end_dt > to_date('${batch_date}','yyyymmdd')
  left join ${iol_schema}.tbps_cpr_cst_inf t4
    on t2.sbf_ecifno = t4.cif_ecifno
   and t4.cif_stt='0'
   and t4.start_dt <= to_date('${batch_date}','yyyymmdd')
   and t4.end_dt > to_date('${batch_date}','yyyymmdd')
 where  (t1.sbd_detailstate) <> '0'
   and t1.start_dt <= to_date('${batch_date}','yyyymmdd')
   and t1.end_dt > to_date('${batch_date}','yyyymmdd')
   and to_date(substr(trim(t1.sbd_salarydate),1,8),'YYYYMMDD') >= to_date('${batch_date}','yyyymmdd') -14
   and to_date(substr(trim(t1.sbd_salarydate),1,8),'YYYYMMDD') <= to_date('${batch_date}','yyyymmdd')
;
commit;


whenever sqlerror exit sql.sqlcode;
--第三组（共九组）
insert /*+ append */ into ${icl_schema}.cmm_elec_chn_tran_dtl(
   etl_dt	                     -- 数据日期
   ,lp_id	                     -- 法人编号
   ,tran_flow_num              -- 交易流水号
   ,ova_chn_flow_num           -- 全局渠道流水号
   ,core_tran_flow_num         -- 核心交易流水号
   ,sorc_sys_flow_num          -- 源系统流水号
   ,osb_tran_flow_num          -- osb交易流水号
   ,rela_timing_task_id        -- 关联定时任务编号
   ,chn_cd                     -- 渠道代码
   ,tran_dt                    -- 交易日期
   ,tran_tm                    -- 交易时间
   ,core_tran_dt               -- 核心交易日期
   ,tran_type_code             -- 交易类型编码
   ,tran_status_cd             -- 交易状态代码
   ,tran_return_code           -- 交易返回码
   ,tran_acct_id               -- 交易账户编号
   ,tran_acct_name             -- 交易账户名称
   ,tran_amt                   -- 交易金额
   ,curr_cd                    -- 币种代码
   ,elec_chn_user_id           -- 电子渠道用户编号
   ,cust_id                    -- 客户编号
   ,termn_ip_addr              -- 终端ip地址
   ,tran_comm_fee              -- 交易手续费
   ,termn_mac_addr             -- 终端mac地址
   ,termn_equip_model          -- 终端设备型号
   ,termn_equip_id             -- 终端设备编号
   ,cntpty_acct_id             -- 交易对手账户编号
   ,cntpty_acct_name           -- 交易对手账户名称
   ,cntpty_acct_open_bank_num  -- 交易对手账户开户行号
   ,cntpty_acct_open_bank_name -- 交易对手账户开户行名
   ,cntpty_acct_prov_cd        -- 交易对手账户省份代码
   ,cntpty_acct_city_cd        -- 交易对手账户城市代码
   ,memo_cd                    -- 摘要代码
   ,memo_descb                 -- 摘要描述
   ,tran_batch_no              -- 交易批次号
   ,tran_org_id                -- 交易机构编号
   ,camp_emply_id              -- 营销员工编号
   ,olbk_tran_src_cd           -- 网银交易来源代码
   ,job_cd                     -- 任务代码
   ,etl_timestamp
)
select
   to_date(trim(t2.ebf_transdate),'yyyymmdd')	                         -- 数据日期
   ,'9999'	                                                     -- 法人编号
   ,(t1.ebd_batchno || '_' || t1.ebd_seqno)                      -- 交易流水号
   ,t3.ctf_src_sendflowno                                        -- 全局渠道流水号
   ,''                                                           -- 核心交易流水号
   ,t3.ctf_parentlogno                                           -- 源系统流水号
   ,''                                                           -- OSB交易流水号
   ,t3.ctf_rootlogno                                             -- 关联定时任务编号
   ,decode(t3.ctf_channel, 'TBP', '301003', 'TBM', '302005')     -- 渠道代码
   ,to_date(substr(trim(t2.ebf_transdate), 0, 8), 'YYYY-MM-DD')   -- 交易日期
   ,t2.ebf_transtime                                             -- 交易时间
   ,''                                                           -- 核心交易日期
   ,'ComplexBatchTransfer'                                       -- 交易类型编码
   ,decode(trim(t1.ebd_detailstate),'C','09','D','03','F','01','I','04','J','01','K','01','L','01','M','05','N','01','R','05','S','00','U','01',t1.ebd_detailstate) -- 交易状态代码
   ,case when t1.ebd_detailstate = 'S' then '0'
         else 'F' end                                            -- 交易返回码
   ,t1.ebd_payeracno                                             -- 交易账户编号
   ,t1.ebd_payeracname                                           -- 交易账户名称
   ,t1.ebd_amount                                                -- 交易金额
   ,t1.ebd_currency                                              -- 币种代码
   ,t2.ebf_userno                                                -- 电子渠道用户编号
   ,t2.ebf_ecifno                                                -- 客户编号
   ,t3.ctf_customerip                                            -- 终端ip地址
   ,case when t1.ebd_fee is null or t1.ebd_fee = '' then 0.00
         else t1.ebd_fee end                                     -- 交易手续费
   ,t3.ctf_clientmac                                             -- 终端mac地址
   ,t3.ctf_clientnunittype                                       -- 终端设备型号
   ,t3.ctf_clientterminateno                                     -- 终端设备编号
   ,t1.ebd_payeeacno                                             -- 交易对手账户编号
   ,decode(sign(length(t1.ebd_payeeacname) - 45),1,substr(t1.ebd_payeeacname, 0, 45),-1,t1.ebd_payeeacname) -- 交易对手账户名称
   ,case when trim(t1.ebd_uniondeptid) is null then '313586000006'
         else t1.ebd_uniondeptid end                             -- 交易对手账户开户行号
   ,case when trim(t1.ebd_uniondeptid) is null then '广东华兴银行'
         else t1.ebd_uniondeptname end                           -- 交易对手账户开户行名
   ,''                                                           -- 交易对手账户省份代码
   ,''                                                           -- 交易对手账户城市代码
   ,''                                                           -- 摘要代码
   ,t1.ebd_remark                                                -- 摘要描述
   ,t1.ebd_batchno                                               -- 交易批次号
   ,t4.cif_opendept                                              -- 交易机构编号
   ,''                                                           -- 营销员工编号
   ,'03'                                                         -- 网银交易来源代码
   ,'tbpsf3'                                                     -- 任务代码
   ,to_timestamp('${batch_timestamp}','yyyy-mm-dd hh24:mi:ss.ff6') -- etl处理时间戳
  from ${iol_schema}.tbps_cpr_ecomplex_batch_detail t1
  left join ${iol_schema}.tbps_cpr_ecomplex_batch_flow t2
    on t1.ebd_batchno = t2.ebf_batchno
   and t2.start_dt <= to_date('${batch_date}','yyyymmdd')
   and t2.end_dt > to_date('${batch_date}','yyyymmdd')
  left join ${iol_schema}.tbps_cpr_trade_flow t3
    on t3.ctf_trade_flowno = t2.ebf_flowno
   and t3.start_dt <= to_date('${batch_date}','yyyymmdd')
   and t3.end_dt > to_date('${batch_date}','yyyymmdd')
  left join ${iol_schema}.tbps_cpr_cst_inf t4
    on t2.ebf_ecifno = t4.cif_ecifno
   and T4.cif_stt = '0'
   and t4.start_dt <= to_date('${batch_date}','yyyymmdd')
   and t4.end_dt > to_date('${batch_date}','yyyymmdd')
 where trim(t1.ebd_detailstate) is not null
   and trim(t2.ebf_flowno) is not null
 --  and t1.etl_dt = to_date('${batch_date}','yyyymmdd')
   and to_date(trim(t2.ebf_transdate),'yyyymmdd') >= to_date('${batch_date}','yyyymmdd') -14
   and to_date(trim(t2.ebf_transdate),'yyyymmdd') <= to_date('${batch_date}','yyyymmdd')
;
commit;

whenever sqlerror exit sql.sqlcode;
--第四组（共九组）
insert /*+ append */ into ${icl_schema}.cmm_elec_chn_tran_dtl(
   etl_dt	                     -- 数据日期
   ,lp_id	                     -- 法人编号
   ,tran_flow_num              -- 交易流水号
   ,ova_chn_flow_num           -- 全局渠道流水号
   ,core_tran_flow_num         -- 核心交易流水号
   ,sorc_sys_flow_num          -- 源系统流水号
   ,osb_tran_flow_num          -- osb交易流水号
   ,rela_timing_task_id        -- 关联定时任务编号
   ,chn_cd                     -- 渠道代码
   ,tran_dt                    -- 交易日期
   ,tran_tm                    -- 交易时间
   ,core_tran_dt               -- 核心交易日期
   ,tran_type_code             -- 交易类型编码
   ,tran_status_cd             -- 交易状态代码
   ,tran_return_code           -- 交易返回码
   ,tran_acct_id               -- 交易账户编号
   ,tran_acct_name             -- 交易账户名称
   ,tran_amt                   -- 交易金额
   ,curr_cd                    -- 币种代码
   ,elec_chn_user_id           -- 电子渠道用户编号
   ,cust_id                    -- 客户编号
   ,termn_ip_addr              -- 终端ip地址
   ,tran_comm_fee              -- 交易手续费
   ,termn_mac_addr             -- 终端mac地址
   ,termn_equip_model          -- 终端设备型号
   ,termn_equip_id             -- 终端设备编号
   ,cntpty_acct_id             -- 交易对手账户编号
   ,cntpty_acct_name           -- 交易对手账户名称
   ,cntpty_acct_open_bank_num  -- 交易对手账户开户行号
   ,cntpty_acct_open_bank_name -- 交易对手账户开户行名
   ,cntpty_acct_prov_cd        -- 交易对手账户省份代码
   ,cntpty_acct_city_cd        -- 交易对手账户城市代码
   ,memo_cd                    -- 摘要代码
   ,memo_descb                 -- 摘要描述
   ,tran_batch_no              -- 交易批次号
   ,tran_org_id                -- 交易机构编号
   ,camp_emply_id              -- 营销员工编号
   ,olbk_tran_src_cd           -- 网银交易来源代码
   ,job_cd                     -- 任务代码
   ,etl_timestamp
)
select
   nvl(to_date(substr(trim(t1.ctf_senddate), 0, 8), 'yyyy-mm-dd'),to_date(substr(trim(t1.ctf_transdate), 0, 8), 'yyyy-mm-dd'))	                                                               -- 数据日期
   ,'9999'	                                                                                           -- 法人编号
   ,t1.ctf_trade_flowno                                                                                -- 交易流水号
   ,t1.ctf_src_sendflowno                                                                              -- 全局渠道流水号
   ,t1.ctf_hostflowno                                                                                  -- 核心交易流水号
   ,t1.ctf_parentlogno                                                                                 -- 源系统流水号
   ,''                                                                                                 -- osb交易流水号
   ,t1.ctf_rootlogno                                                                                   -- 关联定时任务编号
   ,decode(t1.ctf_channel, 'TBP', '301003', 'TBM', '302005')                                           -- 渠道代码
   ,nvl(to_date(substr(trim(t1.ctf_senddate), 0, 8), 'yyyy-mm-dd'),to_date(substr(trim(t1.ctf_transdate), 0, 8), 'yyyy-mm-dd')) -- 交易日期
   ,t1.ctf_transtime                                                                                   -- 交易时间
   ,to_date(trim(t1.ctf_host_returntime), 'yyyy-mm-dd')                                                -- 核心交易日期
   ,decode(t1.ctf_action,'TBP100404','FinancialPrdBuy','TBP08056','discountContractApply','TBP100005','EAccountMoneyOut','TBP100409','FinancialPrdPurchasedRedeem','TBP08052','debitCardBindConfirm','TBP010119','ECheckTransNoRes','CC131413','FinancialPrdPurchasedCancel',t1.CTF_ACTION) -- 交易类型编码
   ,case when t1.ctf_state in ('92','94','96','99') then '01'
         when t1.ctf_state in ('91','98') then '02'
         when t1.ctf_state in ('50') then '03'
         when t1.ctf_state in ('51','53') then '04'
         when t1.ctf_state in ('30','31') then '05'
         when t1.ctf_state in ('52') then '06'
         when t1.ctf_state in ('93','95') then '09'
         when t1.ctf_state in ('90') then '00'
    end                                                                                                -- 交易状态代码
   ,case  when trim(t1.ctf_returncode) is null then '0' when t1.ctf_returncode = '0' then '0' when t1.ctf_returncode = '000000' then '0' when t1.ctf_returncode = '000000000000' then '0'
          else 'F' end                                                                                 -- 交易返回码
   ,t1.ctf_accno                                                                                       -- 交易账户编号
   ,t3.cai_accname                                                                                     -- 交易账户名称
   ,t1.ctf_amonut                                                                                      -- 交易金额
   ,t1.ctf_currency                                                                                    -- 币种代码
   ,t1.ctf_userno                                                                                      -- 电子渠道用户编号
   ,t1.ctf_ecifno                                                                                      -- 客户编号
   ,t1.ctf_customerip                                                                                  -- 终端ip地址
   ,case  when t1.ctf_fee is null or t1.ctf_fee = '' then 0.00 else t1.ctf_fee end                     -- 交易手续费
   ,t1.ctf_clientmac                                                                                   -- 终端mac地址
   ,t1.ctf_clientnunittype                                                                             -- 终端设备型号
   ,t1.ctf_clientterminateno                                                                           -- 终端设备编号
   ,t2.ctl_rcvacc                                                                                      -- 交易对手账户编号
   ,decode(sign(length(t2.ctl_rcvaccname) - 45),1,substr(t2.ctl_rcvaccname, 0, 45),-1,t2.ctl_rcvaccname) -- 交易对手账户名称
   ,nvl(trim(t2.ctl_uniondeptid), t2.ctl_rcvbankid)                                                    -- 交易对手账户开户行号
   ,nvl(trim(t2.ctl_uniondeptname), t5.pbo_bankname)                                                   -- 交易对手账户开户行名
   ,rpad(nvl(trim(t2.ctl_provincecode), t5.pbo_provincecode),6,'0')                                    -- 交易对手账户省份代码
   ,nvl(trim(t2.ctl_citycode), t5.pbo_citycode)                                                        -- 交易对手账户城市代码
   --,t2.ctl_notecode                                                                                  -- 摘要代码
   ,'ZZ'                                                                                               -- 摘要代码
   ,t2.ctl_remark                                                                                      -- 摘要描述
   ,null                                                                                               -- 交易批次号
   ,t4.cif_opendept                                                                                    -- 交易机构编号
   ,''                                                                                                 -- 营销员工编号
   ,'04'                                                                                               -- 网银交易来源代码
   ,'tbpsf4'                                                                                           -- 任务代码
   ,to_timestamp('${batch_timestamp}','yyyy-mm-dd hh24:mi:ss.ff6')                                     -- etl处理时间戳
  from ${iol_schema}.tbps_cpr_trade_flow t1
  left join ${iol_schema}.tbps_cpr_tranflow t2
    on t1.ctf_trade_flowno = t2.ctl_flowno
  -- and t2.etl_dt = to_date('${batch_date}','yyyymmdd')     -- htj是否要改为用ctl_cancelflow转换为日期后做为过滤条件?
  left join ${iol_schema}.tbps_cpr_acc_inf t3
    on t3.cai_accno = t1.ctf_accno
   and t3.start_dt <= to_date('${batch_date}','yyyymmdd')
   and t3.end_dt > to_date('${batch_date}','yyyymmdd')
  left join ${iol_schema}.tbps_cpr_cst_inf t4
    on t1.ctf_ecifno = t4.cif_ecifno
   and t4.cif_stt = '0'
   and t4.start_dt <= to_date('${batch_date}','yyyymmdd')
   and t4.end_dt > to_date('${batch_date}','yyyymmdd')
  left join ${iol_schema}.tbps_cpr_bankno t5
    on t2.ctl_rcvbankid = t5.pbo_bankno
   and t5.pbo_channel = 'IBPS'
   and t5.pbo_stt = 'VALID'
   and t5.start_dt <= to_date('${batch_date}','yyyymmdd')
   and t5.end_dt > to_date('${batch_date}','yyyymmdd')
 where t1.start_dt <= to_date('${batch_date}','yyyymmdd')
   and t1.end_dt > to_date('${batch_date}','yyyymmdd')
   and nvl(to_date(substr(trim(t1.ctf_senddate), 0, 8), 'yyyy-mm-dd'),to_date(substr(trim(t1.ctf_transdate), 0, 8), 'yyyy-mm-dd'))   >= to_date('${batch_date}','yyyymmdd') -14
   and nvl(to_date(substr(trim(t1.ctf_senddate), 0, 8), 'yyyy-mm-dd'),to_date(substr(trim(t1.ctf_transdate), 0, 8), 'yyyy-mm-dd'))   <= to_date('${batch_date}','yyyymmdd')
;
commit;


whenever sqlerror exit sql.sqlcode;
--第五组（共九组）
insert /*+ append */ into ${icl_schema}.cmm_elec_chn_tran_dtl(
   etl_dt	                     -- 数据日期
   ,lp_id	                     -- 法人编号
   ,tran_flow_num              -- 交易流水号
   ,ova_chn_flow_num           -- 全局渠道流水号
   ,core_tran_flow_num         -- 核心交易流水号
   ,sorc_sys_flow_num          -- 源系统流水号
   ,osb_tran_flow_num          -- osb交易流水号
   ,rela_timing_task_id        -- 关联定时任务编号
   ,chn_cd                     -- 渠道代码
   ,tran_dt                    -- 交易日期
   ,tran_tm                    -- 交易时间
   ,core_tran_dt               -- 核心交易日期
   ,tran_type_code             -- 交易类型编码
   ,tran_status_cd             -- 交易状态代码
   ,tran_return_code           -- 交易返回码
   ,tran_acct_id               -- 交易账户编号
   ,tran_acct_name             -- 交易账户名称
   ,tran_amt                   -- 交易金额
   ,curr_cd                    -- 币种代码
   ,elec_chn_user_id           -- 电子渠道用户编号
   ,cust_id                    -- 客户编号
   ,termn_ip_addr              -- 终端ip地址
   ,tran_comm_fee              -- 交易手续费
   ,termn_mac_addr             -- 终端mac地址
   ,termn_equip_model          -- 终端设备型号
   ,termn_equip_id             -- 终端设备编号
   ,cntpty_acct_id             -- 交易对手账户编号
   ,cntpty_acct_name           -- 交易对手账户名称
   ,cntpty_acct_open_bank_num  -- 交易对手账户开户行号
   ,cntpty_acct_open_bank_name -- 交易对手账户开户行名
   ,cntpty_acct_prov_cd        -- 交易对手账户省份代码
   ,cntpty_acct_city_cd        -- 交易对手账户城市代码
   ,memo_cd                    -- 摘要代码
   ,memo_descb                 -- 摘要描述
   ,tran_batch_no              -- 交易批次号
   ,tran_org_id                -- 交易机构编号
   ,camp_emply_id              -- 营销员工编号
   ,olbk_tran_src_cd           -- 网银交易来源代码
   ,job_cd                     -- 任务代码
   ,etl_timestamp
)
select
   case
          when substr(t1.tran_tm, 1, 8) > '19001231' and
               (substr(t1.tran_tm, 1, 4) >= 1900 and
                substr(t1.tran_tm, 1, 4) <= 2099) and
               (substr(t1.tran_tm, 5, 2) >= '01' and
                substr(t1.tran_tm, 5, 2) <= '12') and
               substr(t1.tran_tm, 7, 2) <= 31
		 then to_date(substr(t1.tran_tm, 1, 8), 'yyyymmdd')
          else to_date('19000101', 'yyyymmdd') end	                                                             -- 数据日期
   ,t1.lp_id	                                                                                       -- 法人编号
   ,t1.flow_num                                                                                      -- 交易流水号
   ,t1.sorc_sys_flow_num                                                                             -- 全局渠道流水号
   ,t1.core_tran_flow_num                                                                            -- 核心交易流水号
   ,''                                                                                               -- 源系统流水号
   ,t1.chn_send_flow_num                                                                             -- osb交易流水号
   ,t1.rela_flow_num                                                                                 -- 关联定时任务编号
   ,t1.chn_id                                                                                        -- 渠道代码
   ,(case  when substr(t1.tran_tm, 1, 8) > '19001231' and
              (substr(t1.tran_tm, 1, 4) >= 1900 and
               substr(t1.tran_tm, 1, 4) <= 2099) and
              (substr(t1.tran_tm, 5, 2) >= '01' and
               substr(t1.tran_tm, 5, 2) <= '12') and
              substr(t1.tran_tm, 7, 2) <= 31 then
          to_date(substr(t1.tran_tm, 1, 8), 'yyyymmdd')
         else
          to_date('19000101', 'yyyymmdd')
       end)                                                                                          -- 交易日期
   ,substr(t1.tran_tm, 9, 2) || ':' ||substr(t1.tran_tm, 11, 2) || ':' ||substr(t1.tran_tm, 13, 2)   -- 交易时间
   ,t1.core_tran_dt                                                                                  -- 核心交易日期
   ,t1.tran_type_code                                                                                -- 交易类型编码
   ,decode(trim(t1.onl_bank_tran_status_cd),'90','00','99','01','33','02','50','03','51','04','10','05','11','06','12','07','','03',t1.onl_bank_tran_status_cd) -- 交易状态代码
   ,decode(trim(t1.tran_return_code), '', '1', t1.tran_return_code)                                  -- 交易返回码
   ,t1.tran_acct_num                                                                                 -- 交易账户编号
   ,t10.acct_name                                                                                    -- 交易账户名称
   ,t1.tran_amt                                                                                      -- 交易金额
   ,t1.curr_cd                                                                                       -- 币种代码
   ,substr(t1.whole_unify_cust_id, 1, 10) /*|| substr(t1.whole_unify_cust_id, 1, 10) */              -- 电子渠道用户编号
   ,substr(t1.whole_unify_cust_id, 1, 10)                                                            -- 客户编号
   ,t1.cust_ip_num                                                                                   -- 终端ip地址
   ,t1.comm_fee                                                                                      -- 交易手续费
   ,t1.cust_termn_mac_addr                                                                           -- 终端mac地址
   ,t1.cust_termn_equip_model                                                                        -- 终端设备型号
   ,t1.cust_termn_equip_id                                                                           -- 终端设备编号
   ,t5.recvbl_num                                                                                    -- 交易对手账户编号
   ,t5.recvbl_num_name                                                                               -- 交易对手账户名称
   ,t5.recver_bank_no                                                                                -- 交易对手账户开户行号
   ,t5.recver_bank_name                                                                              -- 交易对手账户开户行名
   ,t5.recver_prov_cd                                                                                -- 交易对手账户省份代码
   ,t5.recver_city_cd                                                                                -- 交易对手账户城市代码
   ,''                                                                                               -- 摘要代码
   ,''                                                                                               -- 摘要描述
   ,''                                                                                               -- 交易批次号
   ,''                                                                                               -- 交易机构编号
   ,t1.camp_job_no                                                                                   -- 营销员工编号
   ,'05'                                                                                             -- 网银交易来源代码
   ,'osbsf1'                                                                                         -- 任务代码
   ,to_timestamp('${batch_timestamp}','yyyy-mm-dd hh24:mi:ss.ff6')                                   -- etl处理时间戳
  from ${iml_schema}.evt_onl_bank_tran_flow t1
  left join ${iml_schema}.agt_ponl_bk_add_acct_h t10
    on t1.tran_acct_num = t10.acct_id
   and t1.whole_unify_cust_id = t10.cust_id
   and t10.start_dt <= to_date('${batch_date}','yyyymmdd')
   and t10.end_dt > to_date('${batch_date}','yyyymmdd')
   and t10.job_cd = 'osbsf1'
  left join ${iml_schema}.evt_onl_bank_tran_dtl t5
    on t1.flow_num = t5.onl_bank_tran_flow_num
   and t5.tran_dt = to_date('${batch_date}','yyyymmdd')
   and t5.job_cd = 'osbsi1'
 where trim(t1.user_seq_id) is null
   and (t1.tran_type_code) <> 'BatchTransfer'
 --  and t1.etl_dt =  to_date('${batch_date}','yyyymmdd')
   and t1.job_cd = 'osbsf1'
   and case
          when substr(t1.tran_tm, 1, 8) > '19001231' and
               (substr(t1.tran_tm, 1, 4) >= 1900 and
                substr(t1.tran_tm, 1, 4) <= 2099) and
               (substr(t1.tran_tm, 5, 2) >= '01' and
                substr(t1.tran_tm, 5, 2) <= '12') and
               substr(t1.tran_tm, 7, 2) <= 31
		 then to_date(substr(t1.tran_tm, 1, 8), 'yyyymmdd')
          else to_date('19000101', 'yyyymmdd') end >= to_date('${batch_date}','yyyymmdd') -14
   and case
          when substr(t1.tran_tm, 1, 8) > '19001231' and
               (substr(t1.tran_tm, 1, 4) >= 1900 and
                substr(t1.tran_tm, 1, 4) <= 2099) and
               (substr(t1.tran_tm, 5, 2) >= '01' and
                substr(t1.tran_tm, 5, 2) <= '12') and
               substr(t1.tran_tm, 7, 2) <= 31
		 then to_date(substr(t1.tran_tm, 1, 8), 'yyyymmdd')
          else to_date('19000101', 'yyyymmdd') end <= to_date('${batch_date}','yyyymmdd')
;
commit;


whenever sqlerror exit sql.sqlcode;
--第六组（共九组）
insert /*+ append */ into ${icl_schema}.cmm_elec_chn_tran_dtl(
   etl_dt	                     -- 数据日期
   ,lp_id	                     -- 法人编号
   ,tran_flow_num              -- 交易流水号
   ,ova_chn_flow_num           -- 全局渠道流水号
   ,core_tran_flow_num         -- 核心交易流水号
   ,sorc_sys_flow_num          -- 源系统流水号
   ,osb_tran_flow_num          -- osb交易流水号
   ,rela_timing_task_id        -- 关联定时任务编号
   ,chn_cd                     -- 渠道代码
   ,tran_dt                    -- 交易日期
   ,tran_tm                    -- 交易时间
   ,core_tran_dt               -- 核心交易日期
   ,tran_type_code             -- 交易类型编码
   ,tran_status_cd             -- 交易状态代码
   ,tran_return_code           -- 交易返回码
   ,tran_acct_id               -- 交易账户编号
   ,tran_acct_name             -- 交易账户名称
   ,tran_amt                   -- 交易金额
   ,curr_cd                    -- 币种代码
   ,elec_chn_user_id           -- 电子渠道用户编号
   ,cust_id                    -- 客户编号
   ,termn_ip_addr              -- 终端ip地址
   ,tran_comm_fee              -- 交易手续费
   ,termn_mac_addr             -- 终端mac地址
   ,termn_equip_model          -- 终端设备型号
   ,termn_equip_id             -- 终端设备编号
   ,cntpty_acct_id             -- 交易对手账户编号
   ,cntpty_acct_name           -- 交易对手账户名称
   ,cntpty_acct_open_bank_num  -- 交易对手账户开户行号
   ,cntpty_acct_open_bank_name -- 交易对手账户开户行名
   ,cntpty_acct_prov_cd        -- 交易对手账户省份代码
   ,cntpty_acct_city_cd        -- 交易对手账户城市代码
   ,memo_cd                    -- 摘要代码
   ,memo_descb                 -- 摘要描述
   ,tran_batch_no              -- 交易批次号
   ,tran_org_id                -- 交易机构编号
   ,camp_emply_id              -- 营销员工编号
   ,olbk_tran_src_cd           -- 网银交易来源代码
   ,job_cd                     -- 任务代码
   ,etl_timestamp
)
select
   t1.tran_dt	                                                             -- 数据日期
   ,t1.lp_id	                                                                                       -- 法人编号
   ,t1.dtl_flow_num                                                                                  -- 交易流水号
   ,t1.sorc_sys_flow_num                                                                             -- 全局渠道流水号
   ,t1.core_tran_flow_num                                                                            -- 核心交易流水号
   ,''                                                                                               -- 源系统流水号
   ,t1.chn_send_flow_num                                                                             -- osb交易流水号
   ,t1.rela_flow_num                                                                                 -- 关联定时任务编号
   ,t1.chn_id                                                                                        -- 渠道代码
   ,t1.tran_dt                                                                                       -- 交易日期
   ,substr(t1.tran_tm, 9, 2) || ':' ||substr(t1.tran_tm, 11, 2) || ':' ||substr(t1.tran_tm, 13, 2)   -- 交易时间
   ,t1.core_tran_dt                                                                                  -- 核心交易日期
   ,t1.tran_type_code                                                                                -- 交易类型编码
   ,t1.dtl_status_cd                                                                                 -- 交易状态代码
   ,decode(trim(t1.return_code), '', '1', t1.return_code)                                            -- 交易返回码
   ,t1.pay_acct_id                                                                                   -- 交易账户编号
   ,t10.acct_name                                                                                    -- 交易账户名称
   ,t1.tran_amt                                                                                      -- 交易金额
   ,t1.curr_cd                                                                                       -- 币种代码
   ,substr(t1.whole_unify_cust_id, 1, 10) /*|| substr(t1.whole_unify_cust_id, 1, 10)*/               -- 电子渠道用户编号
   ,substr(t1.whole_unify_cust_id, 1, 10)                                                            -- 客户编号
   ,t1.cust_ip_num                                                                                   -- 终端ip地址
   ,t1.tran_fee                                                                                      -- 交易手续费
   ,t1.cust_termn_mac_addr                                                                           -- 终端mac地址
   ,t1.cust_termn_equip_model                                                                        -- 终端设备型号
   ,t1.cust_termn_equip_id                                                                           -- 终端设备编号
   ,t1.recvbl_acct_id                                                                                -- 交易对手账户编号
   ,t1.recvbl_acct_name                                                                              -- 交易对手账户名称
   ,t1.recv_bank_no                                                                                  -- 交易对手账户开户行号
   ,t1.recv_bank_name                                                                                -- 交易对手账户开户行名
   ,t1.recv_bank_prov_cd                                                                             -- 交易对手账户省份代码
   ,t1.recv_bank_city_cd                                                                             -- 交易对手账户城市代码
   ,''                                                                                               -- 摘要代码
   ,decode(trim(t1.postsc), '', t1.remark, t1.postsc)                                                -- 摘要描述
   ,t1.batch_id                                                                                      -- 交易批次号
   ,''                                                                                               -- 交易机构编号
   ,t1.camp_job_no                                                                                   -- 营销员工编号
   ,'06'                                                                                             -- 网银交易来源代码
   ,'osbsf2'                                                                                         -- 任务代码
   ,to_timestamp('${batch_timestamp}','yyyy-mm-dd hh24:mi:ss.ff6')                                   -- etl处理时间戳
  from (select a.dtl_flow_num,
               b.sorc_sys_flow_num,
               a.core_tran_flow_num,
               b.chn_send_flow_num,
               b.rela_flow_num,
               b.chn_id,
               a.tran_dt,
               b.tran_tm,
               a.core_tran_dt,
               b.tran_type_code,
               decode(a.dtl_status_cd,'204','00','206','01','205','04','-','03','202','03','203','03','207','03') as dtl_status_cd,
               a.return_code,
               a.pay_acct_id,
               a.tran_amt,
               b.curr_cd,
               b.whole_unify_cust_id,
               b.cust_ip_num,
               a.tran_fee,
               b.cust_termn_mac_addr,
               b.cust_termn_equip_model,
               b.cust_termn_equip_id,
               a.recvbl_acct_id,
               a.recvbl_acct_name,
               a.recv_bank_no,
               a.recv_bank_name,
               a.recv_bank_prov_cd,
               a.recv_bank_city_cd,
               a.postsc,
               a.remark,
               a.batch_id,
               b.camp_job_no,
               b.user_seq_id,
               b.job_cd,
               a.lp_id
          from ${iml_schema}.evt_ponl_bk_batch_tran_dtl a,${iml_schema}.evt_onl_bank_tran_flow b
         where a.onl_bank_tran_flow_num = b.flow_num
           and b.tran_type_code = 'BatchTransfer'
           and a.tran_dt >= to_date('${batch_date}','yyyymmdd') -14
           and a.tran_dt <= to_date('${batch_date}','yyyymmdd')
           and a.job_cd = 'osbsi1'
         --  and b.etl_dt = to_date('${batch_date}','yyyymmdd')
           and b.job_cd = 'osbsf1'
           ) t1
  left join ${iml_schema}.agt_ponl_bk_add_acct_h t10
    on t1.pay_acct_id = t10.acct_id
   and t1.whole_unify_cust_id = t10.cust_id
   and t10.start_dt <= to_date('${batch_date}','yyyymmdd')
   and t10.end_dt > to_date('${batch_date}','yyyymmdd')
   and t10.job_cd = 'osbsf1'
 where trim(t1.user_seq_id) is null
;
commit;


whenever sqlerror exit sql.sqlcode;
--第七组（共九组）
insert /*+ append */ into ${icl_schema}.cmm_elec_chn_tran_dtl(
   etl_dt	                     -- 数据日期
   ,lp_id	                     -- 法人编号
   ,tran_flow_num              -- 交易流水号
   ,ova_chn_flow_num           -- 全局渠道流水号
   ,core_tran_flow_num         -- 核心交易流水号
   ,sorc_sys_flow_num          -- 源系统流水号
   ,osb_tran_flow_num          -- osb交易流水号
   ,rela_timing_task_id        -- 关联定时任务编号
   ,chn_cd                     -- 渠道代码
   ,tran_dt                    -- 交易日期
   ,tran_tm                    -- 交易时间
   ,core_tran_dt               -- 核心交易日期
   ,tran_type_code             -- 交易类型编码
   ,tran_status_cd             -- 交易状态代码
   ,tran_return_code           -- 交易返回码
   ,tran_acct_id               -- 交易账户编号
   ,tran_acct_name             -- 交易账户名称
   ,tran_amt                   -- 交易金额
   ,curr_cd                    -- 币种代码
   ,elec_chn_user_id           -- 电子渠道用户编号
   ,cust_id                    -- 客户编号
   ,termn_ip_addr              -- 终端ip地址
   ,tran_comm_fee              -- 交易手续费
   ,termn_mac_addr             -- 终端mac地址
   ,termn_equip_model          -- 终端设备型号
   ,termn_equip_id             -- 终端设备编号
   ,cntpty_acct_id             -- 交易对手账户编号
   ,cntpty_acct_name           -- 交易对手账户名称
   ,cntpty_acct_open_bank_num  -- 交易对手账户开户行号
   ,cntpty_acct_open_bank_name -- 交易对手账户开户行名
   ,cntpty_acct_prov_cd        -- 交易对手账户省份代码
   ,cntpty_acct_city_cd        -- 交易对手账户城市代码
   ,memo_cd                    -- 摘要代码
   ,memo_descb                 -- 摘要描述
   ,tran_batch_no              -- 交易批次号
   ,tran_org_id                -- 交易机构编号
   ,camp_emply_id              -- 营销员工编号
   ,olbk_tran_src_cd           -- 网银交易来源代码
   ,job_cd                     -- 任务代码
   ,etl_timestamp
)
select
   t1.tran_dt	                                                             -- 数据日期
   ,t1.lp_id	                                                                                       -- 法人编号
   ,t1.flow_num                                                                                      -- 交易流水号
   ,t1.sorc_sys_flow_num                                                                             -- 全局渠道流水号
   ,t1.core_tran_flow_num                                                                            -- 核心交易流水号
   ,''                                                                                               -- 源系统流水号
   ,t1.chn_send_flow_num                                                                             -- osb交易流水号
   ,t1.rela_flow_num                                                                                 -- 关联定时任务编号
   ,t1.chn_id                                                                                        -- 渠道代码
   ,t1.tran_dt                                                                                       -- 交易日期
   ,substr(t1.tran_tm, 9, 2) || ':' ||substr(t1.tran_tm, 11, 2) || ':' ||substr(t1.tran_tm, 13, 2)   -- 交易时间
   ,t1.core_tran_dt                                                                                  -- 核心交易日期
   ,t1.tran_type_code                                                                                -- 交易类型编码
   ,decode(trim(t1.tran_status_cd),'90','00','99','01','33','02','50','03','51','04','10','05','11','06','12','07','','03',t1.tran_status_cd) -- 交易状态代码
   ,decode(trim(t1.tran_return_code), '', '1', t1.tran_return_code)                                  -- 交易返回码
   ,t1.tran_acct_num                                                                                 -- 交易账户编号
   ,t10.acct_name                                                                                    -- 交易账户名称
   ,t1.tran_amt                                                                                      -- 交易金额
   ,t1.curr_cd                                                                                       -- 币种代码
   ,substr(t1.whole_unify_cust_id, 1, 10) /*|| substr(t1.whole_unify_cust_id, 1, 10)*/               -- 电子渠道用户编号
   ,substr(t1.whole_unify_cust_id, 1, 10)                                                            -- 客户编号
   ,t1.cust_ip_num                                                                                   -- 终端ip地址
   ,t1.comm_fee                                                                                      -- 交易手续费
   ,t1.cust_termn_mac_addr                                                                           -- 终端mac地址
   ,t1.cust_termn_equip_model                                                                        -- 终端设备型号
   ,t1.cust_termn_equip_id                                                                           -- 终端设备编号
   ,''                                                                                               -- 交易对手账户编号
   ,''                                                                                               -- 交易对手账户名称
   ,''                                                                                               -- 交易对手账户开户行号
   ,''                                                                                               -- 交易对手账户开户行名
   ,''                                                                                               -- 交易对手账户省份代码
   ,''                                                                                               -- 交易对手账户城市代码
   ,''                                                                                               -- 摘要代码
   ,''                                                                                               -- 摘要描述
   ,''                                                                                               -- 交易批次号
   ,''                                                                                               -- 交易机构编号
   ,t1.camp_job_no                                                                                   -- 营销员工编号
   ,'07'                                                                                             -- 网银交易来源代码
   ,'osbsf3'                                                                                         -- 任务代码
   ,to_timestamp('${batch_timestamp}','yyyy-mm-dd hh24:mi:ss.ff6')                                   -- etl处理时间戳
  from ${iml_schema}.evt_os_priv_serv_bus_flow t1
  left join ${iml_schema}.agt_ponl_bk_add_acct_h t10
    on t1.tran_acct_num = t10.acct_id
   and t1.whole_unify_cust_id = t10.cust_id
   and t10.start_dt <= to_date('${batch_date}','yyyymmdd')
   and t10.end_dt > to_date('${batch_date}','yyyymmdd')
   and t10.job_cd = 'osbsf1'
 where trim(t1.user_seq_id) is null
   and t1.tran_dt >= to_date('${batch_date}','yyyymmdd') -14
   and t1.tran_dt <= to_date('${batch_date}','yyyymmdd')
   and t1.job_cd = 'osbsi1'
;
commit;


whenever sqlerror exit sql.sqlcode;
--第八组（共九组）
insert /*+ append */ into ${icl_schema}.cmm_elec_chn_tran_dtl(
   etl_dt	                     -- 数据日期
   ,lp_id	                     -- 法人编号
   ,tran_flow_num              -- 交易流水号
   ,ova_chn_flow_num           -- 全局渠道流水号
   ,core_tran_flow_num         -- 核心交易流水号
   ,sorc_sys_flow_num          -- 源系统流水号
   ,osb_tran_flow_num          -- osb交易流水号
   ,rela_timing_task_id        -- 关联定时任务编号
   ,chn_cd                     -- 渠道代码
   ,tran_dt                    -- 交易日期
   ,tran_tm                    -- 交易时间
   ,core_tran_dt               -- 核心交易日期
   ,tran_type_code             -- 交易类型编码
   ,tran_status_cd             -- 交易状态代码
   ,tran_return_code           -- 交易返回码
   ,tran_acct_id               -- 交易账户编号
   ,tran_acct_name             -- 交易账户名称
   ,tran_amt                   -- 交易金额
   ,curr_cd                    -- 币种代码
   ,elec_chn_user_id           -- 电子渠道用户编号
   ,cust_id                    -- 客户编号
   ,termn_ip_addr              -- 终端ip地址
   ,tran_comm_fee              -- 交易手续费
   ,termn_mac_addr             -- 终端mac地址
   ,termn_equip_model          -- 终端设备型号
   ,termn_equip_id             -- 终端设备编号
   ,cntpty_acct_id             -- 交易对手账户编号
   ,cntpty_acct_name           -- 交易对手账户名称
   ,cntpty_acct_open_bank_num  -- 交易对手账户开户行号
   ,cntpty_acct_open_bank_name -- 交易对手账户开户行名
   ,cntpty_acct_prov_cd        -- 交易对手账户省份代码
   ,cntpty_acct_city_cd        -- 交易对手账户城市代码
   ,memo_cd                    -- 摘要代码
   ,memo_descb                 -- 摘要描述
   ,tran_batch_no              -- 交易批次号
   ,tran_org_id                -- 交易机构编号
   ,camp_emply_id              -- 营销员工编号
   ,olbk_tran_src_cd           -- 网银交易来源代码
   ,job_cd                     -- 任务代码
   ,etl_timestamp
)
select
   t1.tran_dt	                                                             -- 数据日期
   ,t1.lp_id	                                                                                       -- 法人编号
   ,t1.flow_num                                                                                      -- 交易流水号
   ,t1.sorc_sys_flow_num                                                                             -- 全局渠道流水号
   ,t1.core_tran_flow_num                                                                            -- 核心交易流水号
   ,''                                                                                               -- 源系统流水号
   ,t1.chn_send_flow_num                                                                             -- osb交易流水号
   ,t1.rela_flow_num                                                                                 -- 关联定时任务编号
   ,t1.chn_id                                                                                        -- 渠道代码
   ,t1.tran_dt                                                                                       -- 交易日期
   ,substr(t1.tran_tm, 9, 2) || ':' ||substr(t1.tran_tm, 11, 2) || ':' ||substr(t1.tran_tm, 13, 2)   -- 交易时间
   ,t1.core_tran_dt                                                                                  -- 核心交易日期
   ,t1.tran_type_code                                                                                -- 交易类型编码
   ,decode(trim(t1.tran_status_cd),'90','00','99','01','33','02','50','03','51','04','10','05','11','06','12','07','','03',t1.tran_status_cd) -- 交易状态代码
   ,decode(trim(t1.tran_return_code), '', '1', t1.tran_return_code)                                  -- 交易返回码
   ,t1.tran_acct_num                                                                                 -- 交易账户编号
   ,t10.acct_name                                                                                    -- 交易账户名称
   ,t1.tran_amt                                                                                      -- 交易金额
   ,t1.curr_cd                                                                                       -- 币种代码
   ,substr(t1.whole_unify_cust_id, 1, 10) /*|| substr(t1.whole_unify_cust_id, 1, 10) */              -- 电子渠道用户编号
   ,substr(t1.whole_unify_cust_id, 1, 10)                                                            -- 客户编号
   ,t1.cust_ip_num                                                                                   -- 终端ip地址
   ,t1.comm_fee                                                                                      -- 交易手续费
   ,t1.cust_termn_mac_addr                                                                           -- 终端mac地址
   ,t1.cust_termn_equip_model                                                                        -- 终端设备型号
   ,t1.cust_termn_equip_id                                                                           -- 终端设备编号
   ,''                                                                                               -- 交易对手账户编号
   ,''                                                                                               -- 交易对手账户名称
   ,''                                                                                               -- 交易对手账户开户行号
   ,''                                                                                               -- 交易对手账户开户行名
   ,''                                                                                               -- 交易对手账户省份代码
   ,''                                                                                               -- 交易对手账户城市代码
   ,''                                                                                               -- 摘要代码
   ,''                                                                                               -- 摘要描述
   ,''                                                                                               -- 交易批次号
   ,''                                                                                               -- 交易机构编号
   ,t1.camp_job_no                                                                                   -- 营销员工编号
   ,'08'                                                                                             -- 网银交易来源代码
   ,'osbsf4'                                                                                         -- 任务代码
   ,to_timestamp('${batch_timestamp}','yyyy-mm-dd hh24:mi:ss.ff6')                                   -- etl处理时间戳
  from ${iml_schema}.evt_os_invest_finc_bus_flow t1
  left join ${iml_schema}.agt_ponl_bk_add_acct_h t10
    on t1.tran_acct_num = t10.acct_id
   and t1.whole_unify_cust_id = t10.cust_id
   and t10.start_dt <= to_date('${batch_date}','yyyymmdd')
   and t10.end_dt > to_date('${batch_date}','yyyymmdd')
   and t10.job_cd = 'osbsf1'
 where trim(t1.user_seq_id) is null
   and TRIM(T1.TRAN_CHN_CD) NOT IN ('TBP','-')   -- TBP企业网银、未知
   and t1.tran_dt >= to_date('${batch_date}','yyyymmdd') -14
   and t1.tran_dt <= to_date('${batch_date}','yyyymmdd')
   and t1.job_cd = 'osbsi1'
;
commit;


whenever sqlerror exit sql.sqlcode;
--第九组（共九组）个人网银鉴权流水
insert /*+ append */ into ${icl_schema}.cmm_elec_chn_tran_dtl(
   etl_dt	                     -- 数据日期
   ,lp_id	                     -- 法人编号
   ,tran_flow_num              -- 交易流水号
   ,ova_chn_flow_num           -- 全局渠道流水号
   ,core_tran_flow_num         -- 核心交易流水号
   ,sorc_sys_flow_num          -- 源系统流水号
   ,osb_tran_flow_num          -- osb交易流水号
   ,rela_timing_task_id        -- 关联定时任务编号
   ,chn_cd                     -- 渠道代码
   ,tran_dt                    -- 交易日期
   ,tran_tm                    -- 交易时间
   ,core_tran_dt               -- 核心交易日期
   ,tran_type_code             -- 交易类型编码
   ,tran_status_cd             -- 交易状态代码
   ,tran_return_code           -- 交易返回码
   ,tran_acct_id               -- 交易账户编号
   ,tran_acct_name             -- 交易账户名称
   ,tran_amt                   -- 交易金额
   ,curr_cd                    -- 币种代码
   ,elec_chn_user_id           -- 电子渠道用户编号
   ,cust_id                    -- 客户编号
   ,termn_ip_addr              -- 终端ip地址
   ,tran_comm_fee              -- 交易手续费
   ,termn_mac_addr             -- 终端mac地址
   ,termn_equip_model          -- 终端设备型号
   ,termn_equip_id             -- 终端设备编号
   ,cntpty_acct_id             -- 交易对手账户编号
   ,cntpty_acct_name           -- 交易对手账户名称
   ,cntpty_acct_open_bank_num  -- 交易对手账户开户行号
   ,cntpty_acct_open_bank_name -- 交易对手账户开户行名
   ,cntpty_acct_prov_cd        -- 交易对手账户省份代码
   ,cntpty_acct_city_cd        -- 交易对手账户城市代码
   ,memo_cd                    -- 摘要代码
   ,memo_descb                 -- 摘要描述
   ,tran_batch_no              -- 交易批次号
   ,tran_org_id                -- 交易机构编号
   ,camp_emply_id              -- 营销员工编号
   ,olbk_tran_src_cd           -- 网银交易来源代码
   ,job_cd                     -- 任务代码
   ,etl_timestamp
)
select
   case  when substr(t1.TRAN_TM, 1, 8) > '19001231' and
              (substr(t1.TRAN_TM, 1, 4) >= 1900 and
               substr(t1.TRAN_TM, 1, 4) <= 2099) and
              (substr(t1.TRAN_TM, 5, 2) >= '01' and
               substr(t1.TRAN_TM, 5, 2) <= '12') and
              substr(t1.TRAN_TM, 7, 2) <= 31 then
          to_date(substr(t1.TRAN_TM, 1, 8), 'YYYYMMDD')
         else
          to_date('19000101', 'YYYYMMDD')
       end                                                               -- 数据日期
   ,t1.lp_id	                                                                                       -- 法人编号
   ,t1.flow_num                                                                                      -- 交易流水号
   ,t1.sorc_sys_flow_num                                                                             -- 全局渠道流水号
   ,t1.core_tran_flow_num                                                                            -- 核心交易流水号
   ,''                                                                                               -- 源系统流水号
   ,t1.chn_send_flow_num                                                                             -- osb交易流水号
   ,t1.rela_flow_num                                                                                 -- 关联定时任务编号
   ,t1.chn_id                                                                                        -- 渠道代码
   ,case  when substr(t1.tran_tm, 1, 8) > '19001231' and
              (substr(t1.tran_tm, 1, 4) >= 1900 and
               substr(t1.tran_tm, 1, 4) <= 2099) and
              (substr(t1.tran_tm, 5, 2) >= '01' and
               substr(t1.tran_tm, 5, 2) <= '12') and
              substr(t1.tran_tm, 7, 2) <= 31 then
          to_date(substr(t1.tran_tm, 1, 8), 'YYYYMMDD')
         else to_date('19000101', 'YYYYMMDD') end                                                    -- 交易日期
   ,substr(t1.tran_tm, 9, 2) || ':' ||substr(t1.tran_tm, 11, 2) || ':' ||substr(t1.tran_tm, 13, 2)   -- 交易时间
   ,''                                                                                               -- 核心交易日期
   ,t1.tran_type_code                                                                                -- 交易类型编码
   ,decode(trim(t1.tran_status_cd),'90','00','99','01','33','02','50','03','51','04','10','05','11','06','12','07','','03',t1.tran_status_cd)  -- 交易状态代码
   ,decode(t1.return_code, '', '1', t1.return_code)                                                  -- 交易返回码
   ,t1.acct_id                                                                                       -- 交易账户编号
   ,t10.acct_name                                                                                    -- 交易账户名称
   ,t1.tran_amt                                                                                      -- 交易金额
   ,t1.curr_cd                                                                                       -- 币种代码
   ,substr(t1.cust_id, 1, 10)                                                                        -- 电子渠道用户编号
   ,substr(t1.cust_id, 1, 10)                                                                        -- 客户编号
   ,t1.cust_ip                                                                                       -- 终端IP地址
   ,''                                                                                               -- 交易手续费
   ,t1.cust_termn_mac_addr                                                                           -- 终端MAC地址
   ,t1.cust_termn_equip_model                                                                        -- 终端设备型号
   ,t1.cust_termn_equip_id                                                                           -- 终端设备编号
   ,''                                                                                               -- 交易对手账户编号
   ,''                                                                                               -- 交易对手账户名称
   ,''                                                                                               -- 交易对手账户开户行号
   ,''                                                                                               -- 交易对手账户开户行名
   ,''                                                                                               -- 交易对手账户省份代码
   ,''                                                                                               -- 交易对手账户城市代码
   ,''                                                                                               -- 摘要代码
   ,''                                                                                               -- 摘要描述
   ,''                                                                                               -- 交易批次号
   ,''                                                                                               -- 交易机构编号
   ,''                                                                                               -- 营销员工编号
   ,'09'                                                                                             -- 网银交易来源代码
   ,'osbsf5'                                                                                         -- 任务代码
   ,to_timestamp('${batch_timestamp}','yyyy-mm-dd hh24:mi:ss.ff6')                                   -- etl处理时间戳
  from ${iml_schema}.evt_ponl_bk_authen_flow t1
  left join ${iml_schema}.agt_ponl_bk_add_acct_h T10
    on t1.acct_id = t10.acct_id
   and t1.cust_id = t10.cust_id
   and t10.start_dt <= to_date('${batch_date}','yyyymmdd')
   and t10.end_dt > to_date('${batch_date}','yyyymmdd')
   and t10.job_cd = 'osbsf1'
 where t1.job_cd = 'osbsf1'
   and case  when substr(t1.TRAN_TM, 1, 8) > '19001231' and
              (substr(t1.TRAN_TM, 1, 4) >= 1900 and
               substr(t1.TRAN_TM, 1, 4) <= 2099) and
              (substr(t1.TRAN_TM, 5, 2) >= '01' and
               substr(t1.TRAN_TM, 5, 2) <= '12') and
              substr(t1.TRAN_TM, 7, 2) <= 31 then
          to_date(substr(t1.TRAN_TM, 1, 8), 'YYYYMMDD')
         else
          to_date('19000101', 'YYYYMMDD')
       end >= to_date('${batch_date}','yyyymmdd') -14
   and case  when substr(t1.TRAN_TM, 1, 8) > '19001231' and
              (substr(t1.TRAN_TM, 1, 4) >= 1900 and
               substr(t1.TRAN_TM, 1, 4) <= 2099) and
              (substr(t1.TRAN_TM, 5, 2) >= '01' and
               substr(t1.TRAN_TM, 5, 2) <= '12') and
              substr(t1.TRAN_TM, 7, 2) <= 31 then
          to_date(substr(t1.TRAN_TM, 1, 8), 'YYYYMMDD')
         else
          to_date('19000101', 'YYYYMMDD')
       end <= to_date('${batch_date}','yyyymmdd') 
;
commit;

-- 2.2 exchage ex table and target table
--alter table ${icl_schema}.cmm_elec_chn_tran_dtl exchange partition p_${batch_date} with table ${icl_schema}.cmm_elec_chn_tran_dtl_ex;

-- 3.1 drop ex table
--drop table ${icl_schema}.cmm_elec_chn_tran_dtl_ex purge;

-- 3.2 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${icl_schema}',tabname => 'cmm_elec_chn_tran_dtl',partname => 'p_${batch_date}',granularity => 'PARTITION', degree => 8, cascade => true);