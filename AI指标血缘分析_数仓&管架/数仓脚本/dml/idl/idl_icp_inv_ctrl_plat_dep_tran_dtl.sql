/*
Purpose:    应用集市层-建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd idl_icp_inv_ctrl_plat_dep_tran_dtl
CreateDate: 20180515
FileType:   DML
Logs:
    zjj 2018-05-15 新建表本
    徐子豪 20230627 修改【第一组 核心交易对方名称、交易对方账号、交易对方账号开户行】逻辑口径,调整模型数据保留策略。
*/

set timing on

-- 1 alter parallel
alter session force parallel query parallel 4;
alter session force parallel dml parallel 4;
-- alter session force parallel ddl parallel 4;


-- 2.1 drop timeout partition and add partition
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none;
alter table ${idl_schema}.icp_inv_ctrl_plat_dep_tran_dtl drop partition p_${batch_date};

-- 2.2 add today partition
whenever sqlerror exit sql.sqlcode;
alter table ${idl_schema}.icp_inv_ctrl_plat_dep_tran_dtl add  partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

-- 2.3 insert data target table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ into ${idl_schema}.icp_inv_ctrl_plat_dep_tran_dtl (
    etl_dt  -- 数据日期
    ,chn  -- 渠道
    ,dtl_seq_num  -- 明细序号
    ,acct_name  -- 账户名称
    ,tran_type  -- 交易类型
    ,debit_crdt_flg  -- 借贷标志
    ,curr  -- 币种
    ,tran_amt  -- 交易金额
    ,tran_bal  -- 交易余额
    ,tran_dt  -- 交易日期
    ,tran_tm  -- 交易时间
    ,tran_flow_num  -- 交易流水号
    ,tran_cntpty_name  -- 交易对方名称
    ,tran_cntpty_acct_num  -- 交易对方账号
    ,tran_cntpty_acct_open_bank  -- 交易对方账号开户行
    ,tran_memo  -- 交易摘要
    ,tran_brac_name  -- 交易网点名称
    ,tran_brac_cd  -- 交易网点代码
    ,tran_brac_addr  -- 交易网点地址
    ,vouch_kind  -- 凭证种类
    ,vouch_num  -- 凭证号
    ,cash_flg  -- 现金标志
    ,termn_no  -- 终端号
    ,tran_is_sucs  -- 交易是否成功
    ,ip_addr  -- IP地址
    ,mac_addr  -- MAC地址
    ,tran_teller_no  -- 交易柜员号
    ,remark  -- 备注
    ,acct_seq_num  -- 账户序号
    ,cert_type_cd  -- 证件类型代码
    ,cert_no  -- 证件号码
    ,open_acct_org  -- 开户机构
    ,acct_num  -- 账号
    ,rev_tran_flg  -- 反交易标志
    ,revs_tran_idf  -- 冲正交易标识
    ,auth_teller_no  -- 授权柜员号
    ,public_agent_phone  -- 代办人联系电话
    ,public_agent_name  -- 代办人姓名
    ,public_agent_cert_no  -- 代办人证件号码
    ,public_agent_cert_type  -- 代办人证件类型
    ,job_cd  -- 任务代码
    ,etl_timestamp  -- 数据处理时间
)
select
    to_date('${batch_date}','yyyymmdd') as etl_dt  -- 数据日期
    ,replace(replace(t1.chn_cd,chr(13),''),chr(10),'')  -- 渠道
    ,replace(replace(t1.acct_bill_flow_num,chr(13),''),chr(10),'')  -- 明细序号
    ,replace(replace(t1.cust_name,chr(13),''),chr(10),'')  -- 账户名称
    ,replace(replace(t1.tran_kind_cd,chr(13),''),chr(10),'')  -- 交易类型
    ,replace(replace(t1.debit_crdt_dir_cd,chr(13),''),chr(10),'')  -- 借贷标志
    ,replace(replace(t1.tran_curr_cd,chr(13),''),chr(10),'')  -- 币种
    ,t1.tran_amt  -- 交易金额
    ,t1.tran_bal  -- 交易余额
    ,t1.tran_dt  -- 交易日期
    , to_char(t1.tran_timestamp,'YYYYMMDDHH24MISS')  -- 交易时间
    ,replace(replace(t1.tran_flow_num,chr(13),''),chr(10),'')  -- 交易流水号
    ,replace(replace(t1.real_cntpty_acct_name,chr(13),''),chr(10),'')  -- 交易对方名称
    ,replace(replace(t1.real_cntpty_acct_id,chr(13),''),chr(10),'')  -- 交易对方账号
    ,replace(replace(t1.real_cntpty_fin_inst_cd,chr(13),''),chr(10),'')  -- 交易对方账号开户行
    ,replace(replace(t1.memo_cd_descb,chr(13),''),chr(10),'')  -- 交易摘要
    ,replace(replace(t2.org_name,chr(13),''),chr(10),'')  -- 交易网点名称
    ,replace(replace(t1.acct_org_id,chr(13),''),chr(10),'')  -- 交易网点代码
    ,replace(replace(t2.phys_addr,chr(13),''),chr(10),'')  -- 交易网点地址
    ,replace(replace(t1.vouch_kind_cd,chr(13),''),chr(10),'')  -- 凭证种类    
    ,replace(replace(t1.tran_vouch_id,chr(13),''),chr(10),'')  -- 凭证号
    ,replace(replace(t1.cash_trans_flg,chr(13),''),chr(10),'')  -- 现金标志
    ,replace(replace(t1.termn_id,chr(13),''),chr(10),'')  -- 终端号
    ,replace(replace(t1.tran_status_cd,chr(13),''),chr(10),'')  -- 交易是否成功
--    ,''          -- 客户端IP地址
--    ,''          -- 客户终端MAC地址
    ,replace(replace(t1.client_ip_addr,chr(13),''),chr(10),'')  -- IP地址
    ,replace(replace(t1.cust_termn_mac_addr,chr(13),''),chr(10),'')  -- MAC地址
    ,replace(replace(t1.tran_teller_id,chr(13),''),chr(10),'')  -- 交易柜员号
    ,replace(replace(t1.chn_cd,chr(13),''),chr(10),'')  -- 备注
    ,replace(replace(t1.sub_acct_id,chr(13),''),chr(10),'')  -- 账户序号
    ,case when t4.cust_id is not null then t4.cert_type_cd
     when t5.soci_crdt_cd is not null then '2313'
     when t5.orgnz_cd is not null then '2020'
     when t5.fin_lics_num is not null then '2090'
     when t5.bus_lics_num is not null then '2010'
     when t5.nation_tax_rgst_cert_num is not null then '2071'
     when t5.local_tax_rgst_cert_num is not null then '2072'
     else '' end  -- 证件类型代码
    ,case when t4.cust_id is not null then t4.cert_no
     when t5.soci_crdt_cd is not null then t5.soci_crdt_cd
     when t5.orgnz_cd is not null then t5.orgnz_cd
     when t5.fin_lics_num is not null then t5.fin_lics_num
     when t5.bus_lics_num is not null then t5.bus_lics_num
     when t5.nation_tax_rgst_cert_num is not null then t5.nation_tax_rgst_cert_num
     when t5.local_tax_rgst_cert_num is not null then t5.local_tax_rgst_cert_num
     else '' end  -- 证件号码
    ,replace(replace(t1.acct_org_id,chr(13),''),chr(10),'')  -- 开户机构
    ,replace(replace(t1.cust_acct_id,chr(13),''),chr(10),'')  -- 账号
    ,replace(replace(t1.erase_acct_flg,chr(13),''),chr(10),'')  -- 反交易标志
    ,replace(replace(t1.revs_flg,chr(13),''),chr(10),'')  -- 冲正交易标识
    ,replace(replace(t1.auth_teller_id,chr(13),''),chr(10),'')  -- 授权柜员号
    ,replace(replace(t1.agent_phone,chr(13),''),chr(10),'')  -- 代办人联系电话
    ,replace(replace(t1.agent_name,chr(13),''),chr(10),'')  -- 代办人姓名
    ,replace(replace(t1.agent_cert_no,chr(13),''),chr(10),'')  -- 代办人证件号码
    ,replace(replace(t1.agent_cert_type_cd,chr(13),''),chr(10),'')  -- 代办人证件类型
    ,replace(replace(t1.job_cd,chr(13),''),chr(10),'')  -- 任务代码
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp  -- 数据处理时间
from ${icl_schema}.cmm_dep_acct_tran_dtl  t1--存款账户交易明细
left join ${icl_schema}.cmm_intnal_org_info  t2--内部机构信息表
    on t1.tran_org_id = t2.org_id
    and t2.etl_dt = to_date('${batch_date}','yyyymmdd')
left join ${icl_schema}.cmm_dep_cust_acct_info t3  --存款主账户信息
    on t1.cntpty_acct_id = t3.cust_acct_id
    and t3.etl_dt = to_date('${batch_date}','yyyymmdd')
left join ${icl_schema}.cmm_indv_cust_basic_info t4  --个人客户基本信息
    on t3.cust_id = t4.cust_id 
    and t4.etl_dt = to_date('${batch_date}','yyyymmdd')
left join ${icl_schema}.cmm_corp_cust_basic_info t5  --对公客户基本信息
    on t3.cust_id = t5.cust_id
    and t5.etl_dt = to_date('${batch_date}','yyyymmdd')
where t1.etl_dt = to_date('${batch_date}','yyyymmdd')
    and t1.entry_flg = '1'

union all

select
    to_date('${batch_date}','yyyymmdd') as etl_dt  -- 数据日期
    ,replace(replace(t1.tran_chn_cd,chr(13),''),chr(10),'')  -- 渠道
    ,''  -- 明细序号
    ,replace(replace(t3.acct_name,chr(13),''),chr(10),'')  -- 账户名称
    ,replace(replace(t1.tran_type_cd,chr(13),''),chr(10),'')   -- 交易类型
    ,replace(replace(t1.debit_crdt_dir_cd,chr(13),''),chr(10),'')  -- 借贷标志
    ,'CNY'  -- 币种
    ,t1.tran_amt  -- 交易金额
    ,t1.dep_rcpt_bal  -- 交易余额
    ,t1.tran_dt  -- 交易日期
    ,to_char(t1.tran_dt,'yyyymmdd')||t1.tran_tm  -- 交易时间
    ,replace(replace(t1.tran_flow_id,chr(13),''),chr(10),'')  -- 交易流水号
    ,replace(replace(t1.cntpty_acct_name,chr(13),''),chr(10),'')  -- 交易对方名称
    ,replace(replace(t1.cntpty_acct_id,chr(13),''),chr(10),'')  -- 交易对方账号
    ,replace(replace(t1.cntpty_org_id,chr(13),''),chr(10),'')  -- 交易对方账号开户行
    ,''  -- 交易摘要
    ,replace(replace(t2.org_name,chr(13),''),chr(10),'')  -- 交易网点名称
    ,replace(replace(t1.tran_org_id,chr(13),''),chr(10),'')  -- 交易网点代码
    ,replace(replace(t2.phys_addr,chr(13),''),chr(10),'')  -- 交易网点地址
    ,''  -- 凭证种
    ,''  -- 凭证号 
    ,''  -- 现金标志 
    ,''  -- 终端号  
    ,replace(replace(t1.tran_status_cd,chr(13),''),chr(10),'')  -- 交易是否成功
    ,''  -- IP地址           
    ,''  -- MAC地址         
    ,'SYS'  -- 交易柜员号   
    ,''  -- 备注              
    ,replace(replace(t1.dep_sub_acct_id,chr(13),''),chr(10),'')  -- 账户序号
    ,''  -- 证件类型代码 
    ,''  -- 证件号码 
    ,replace(replace(t3.open_acct_org_id,chr(13),''),chr(10),'')  -- 开户机构
    ,replace(replace(t1.acct_id,chr(13),''),chr(10),'')  -- 账号
    ,'0'  -- 反交易标志            
    ,'1'  -- 冲正交易标识          
    ,'SYS'  -- 授权柜员号          
    ,''  --  代办人联系电话    
    ,''  --  代办人姓名       
    ,''  --  代办人证件号码  
    ,''  --  代办人证件类型
    ,replace(replace(t1.job_cd,chr(13),''),chr(10),'')  -- 任务代码
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp  -- 数据处理时间
from ${iml_schema}.evt_ifs_acct_tran_dtl t1  --联合存款账户交易明细
left join ${icl_schema}.cmm_intnal_org_info  t2   --内部机构信息表
    on t1.tran_org_id = t2.org_id
    and t2.etl_dt = to_date('${batch_date}','yyyymmdd')
left join ${icl_schema}.cmm_ifs_acct_info t3   --联合存款分户信息
    on t1.acct_id = t3.cust_acct_sub_acct_num 
    and t1.dep_sub_acct_id = t3.cust_acct_id
    and (t3.etl_dt = to_date('${batch_date}','yyyymmdd')
       or (t3.etl_dt = to_date('${last_year_end}', 'yyyymmdd')
       and t3.clos_acct_dt < to_date('${year_start}', 'yyyymmdd')
       and t3.dep_acct_status_cd = 'C'
       and t3.currt_bal = 0 ))
where t1.etl_dt = to_date('${batch_date}','yyyymmdd') ;
commit;


-- 4 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${idl_schema}',tabname => 'icp_inv_ctrl_plat_dep_tran_dtl',partname => 'p_${batch_date}', granularity => 'PARTITION', degree => 8, cascade => true);