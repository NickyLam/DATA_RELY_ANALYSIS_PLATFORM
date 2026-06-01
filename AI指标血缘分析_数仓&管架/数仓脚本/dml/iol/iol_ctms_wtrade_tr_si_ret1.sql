/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_ctms_wtrade_tr_si
CreateDate: 20180515
Logs:
    zjj 2018-05-15 新建脚本
*/

set timing on

-- 1.1 alter parallel
alter session force parallel query parallel 3;
alter session force parallel dml parallel 3;

declare
  v_var    number(3)  :=0;
  v_sql    varchar2(1000);
  
begin
  for tb in (SELECT TO_CHAR(END_DT, 'yyyymmdd') as end_dt
               FROM (SELECT END_DT,
                            ROW_NUMBER() OVER(PARTITION BY END_DT ORDER BY END_DT) RN
                       FROM ctms_wtrade_tr_si_bak${batch_date})
              WHERE RN = 1
 ) loop

  select count(partition_name) into v_var 
    from user_tab_partitions 
   where substr(partition_name,3) = tb.end_dt 
     and table_name = upper('ctms_wtrade_tr_si');
  
  if v_var <> 0 then 
    execute immediate 'alter table ctms_wtrade_tr_si drop partition p_' || tb.end_dt;
  end if;
  
    v_sql :='alter table ctms_wtrade_tr_si add partition p_' || tb.end_dt || ' values(to_date(' || tb.end_dt || ',''yyyymmdd''))';
    
    execute immediate v_sql;

  
   -- 回插所有数据    
   
insert /*+ append */ into ${iol_schema}.ctms_wtrade_tr_si(
            aspclient_id -- 
            ,serial_number -- 
            ,bs -- 
            ,cash_acc_ename -- 
            ,cash_acc_cname -- 
            ,cash_acc_bank -- 
            ,cash_acc_no -- 
            ,cash_acc_bank_ex -- 
            ,bond_acc_name -- 
            ,bond_acc_bank -- 
            ,bond_acc_no -- 
            ,g_cash_amt -- 
            ,g_bond_id -- 
            ,g_bond_name -- 
            ,g_bond_amt -- 
            ,g_bond_total_amt -- 
            ,g_ca_name -- 
            ,g_ca_bank -- 
            ,g_ca_no -- 
            ,g_ca_bank_ex -- 
            ,g_ba_name -- 
            ,g_ba_bank -- 
            ,g_ba_no -- 
            ,g_stl_date -- 
            ,g_mgr_bank -- 
            ,lastmodified -- 
            ,datasymbol_id -- 
            ,settle_instr_name -- 清算路径名称
            ,swift_code -- Swift Code编码
            ,bond_owner -- 托管账号开户人
            ,custody_institution_type -- 托管机构类型
            ,bond_settle_instr_name -- 托管清算路径名称
            ,bond_escrow_opening_bank -- 债券托管开户行
            ,escrow_agency -- 托管机构
            ,bond_acc_ename -- 债券托管账户英文户名
            ,bond_escrow_manage_agency -- 债券托管管理机构
            ,bond_swift_code -- 托管机构SWIFT CODE
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
            aspclient_id -- 
            ,serial_number -- 
            ,bs -- 
            ,cash_acc_ename -- 
            ,cash_acc_cname -- 
            ,cash_acc_bank -- 
            ,cash_acc_no -- 
            ,cash_acc_bank_ex -- 
            ,bond_acc_name -- 
            ,bond_acc_bank -- 
            ,bond_acc_no -- 
            ,g_cash_amt -- 
            ,g_bond_id -- 
            ,g_bond_name -- 
            ,g_bond_amt -- 
            ,g_bond_total_amt -- 
            ,g_ca_name -- 
            ,g_ca_bank -- 
            ,g_ca_no -- 
            ,g_ca_bank_ex -- 
            ,g_ba_name -- 
            ,g_ba_bank -- 
            ,g_ba_no -- 
            ,g_stl_date -- 
            ,g_mgr_bank -- 
            ,lastmodified -- 
            ,datasymbol_id -- 
            ,' ' as settle_instr_name -- 清算路径名称
            ,' ' as swift_code -- Swift Code编码
            ,' ' as bond_owner -- 托管账号开户人
            ,' ' as custody_institution_type -- 托管机构类型
            ,' ' as bond_settle_instr_name -- 托管清算路径名称
            ,' ' as bond_escrow_opening_bank -- 债券托管开户行
            ,' ' as escrow_agency -- 托管机构
            ,' ' as bond_acc_ename -- 债券托管账户英文户名
            ,' ' as bond_escrow_manage_agency -- 债券托管管理机构
            ,' ' as bond_swift_code -- 托管机构SWIFT CODE
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
from ctms_wtrade_tr_si_bak${batch_date}
where end_dt = to_date(tb.end_dt,'yyyymmdd');
commit;

end loop;
end;
/
