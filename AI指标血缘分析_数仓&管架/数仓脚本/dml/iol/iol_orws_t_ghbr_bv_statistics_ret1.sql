/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_orws_t_ghbr_bv_statistics
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
                       FROM orws_t_ghbr_bv_statistics_bak_${batch_date})
              WHERE RN = 1
 ) loop

  select count(partition_name) into v_var 
    from user_tab_partitions 
   where substr(partition_name,3) = tb.end_dt 
     and table_name = upper('orws_t_ghbr_bv_statistics');
  
  if v_var <> 0 then 
    execute immediate 'alter table orws_t_ghbr_bv_statistics drop partition p_' || tb.end_dt;
  end if;
  
    v_sql :='alter table orws_t_ghbr_bv_statistics add partition p_' || tb.end_dt || ' values(to_date(' || tb.end_dt || ',''yyyymmdd''))';
    
    execute immediate v_sql;

  
   -- 回插所有数据    
   
insert /*+ append */ into ${iol_schema}.orws_t_ghbr_bv_statistics(
            id -- 主键
            ,data_date -- 
            ,data_type -- 
            ,is_shield -- 
            ,hb_num -- 
            ,hb_name -- 
            ,bb_num -- 
            ,bb_name -- 
            ,sb_num -- 
            ,sb_name -- 
            ,organ_num -- 
            ,organ_name -- 
            ,display_num -- 
            ,display_name -- 
            ,total_txnvol -- 
            ,total_weight_txnvol -- 
            ,cbss_txnvol -- 
            ,cbss_weight_txnvol -- 
            ,pwbs_txnvol -- 
            ,pwbs_weight_txnvol -- 
            ,ifms_txnvol -- 
            ,ifms_weight_txnvol -- 
            ,pbss_txnvol -- 
            ,pbss_weight_txnvol -- 
            ,isbs_txnvol -- 
            ,isbs_weight_txnvol -- 
            ,crss_txnvol -- 
            ,crss_weight_txnvol -- 
            ,svss_txnvol -- 
            ,svss_weight_txnvol -- 
            ,amls_txnvol -- 
            ,amls_weight_txnvol -- 
            ,bdms_txnvol -- 
            ,bdms_weight_txnvol -- 
            ,mpcs_txnvol -- 
            ,mpcs_weight_txnvol -- 
            ,ma_txnvol -- 
            ,ma_weight_txnvol -- 
            ,period_type -- 
            ,teller_type -- 
            ,auto_txnvol -- 
            ,auto_weight_txnvol -- 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
            id -- 主键
            ,data_date -- 
            ,data_type -- 
            ,is_shield -- 
            ,hb_num -- 
            ,hb_name -- 
            ,bb_num -- 
            ,bb_name -- 
            ,sb_num -- 
            ,sb_name -- 
            ,organ_num -- 
            ,organ_name -- 
            ,display_num -- 
            ,display_name -- 
            ,total_txnvol -- 
            ,total_weight_txnvol -- 
            ,cbss_txnvol -- 
            ,cbss_weight_txnvol -- 
            ,pwbs_txnvol -- 
            ,pwbs_weight_txnvol -- 
            ,ifms_txnvol -- 
            ,ifms_weight_txnvol -- 
            ,pbss_txnvol -- 
            ,pbss_weight_txnvol -- 
            ,isbs_txnvol -- 
            ,isbs_weight_txnvol -- 
            ,crss_txnvol -- 
            ,crss_weight_txnvol -- 
            ,svss_txnvol -- 
            ,svss_weight_txnvol -- 
            ,amls_txnvol -- 
            ,amls_weight_txnvol -- 
            ,bdms_txnvol -- 
            ,bdms_weight_txnvol -- 
            ,mpcs_txnvol -- 
            ,mpcs_weight_txnvol -- 
            ,ma_txnvol -- 
            ,ma_weight_txnvol -- 
            ,period_type -- 
            ,teller_type -- 
            ,auto_txnvol -- 
            ,auto_weight_txnvol -- 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
from orws_t_ghbr_bv_statistics_bak_${batch_date}
where end_dt = to_date(tb.end_dt,'yyyymmdd');
commit;

end loop;
end;
/
