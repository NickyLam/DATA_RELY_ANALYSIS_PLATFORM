/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_eifs_t01_corp_group_info
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
                       FROM eifs_t01_corp_group_info_bak${batch_date})
              WHERE RN = 1
 ) loop

  select count(partition_name) into v_var 
    from user_tab_partitions 
   where substr(partition_name,3) = tb.end_dt 
     and table_name = upper('eifs_t01_corp_group_info');
  
  if v_var <> 0 then 
    execute immediate 'alter table eifs_t01_corp_group_info drop partition p_' || tb.end_dt;
  end if;
  
    v_sql :='alter table eifs_t01_corp_group_info add partition p_' || tb.end_dt || ' values(to_date(' || tb.end_dt || ',''yyyymmdd''))';
    
    execute immediate v_sql;

  
   -- 回插所有数据    
   
insert /*+ append */ into ${iol_schema}.eifs_t01_corp_group_info(
            group_id -- 群体id
            ,group_num -- 集团编号
            ,group_name -- 集团名称
            ,group_short_name -- 集团简称
            ,group_en_name -- 集团英文名称
            ,phys_addr_cty_zone_cd -- 国家和地区
            ,group_work_addr_dist_cd -- 集团办公地行政区划
            ,group_dom_work_addr -- 集团国内办公地址
            ,trade_group_ind -- 同业集团标志
            ,group_mem_cnt -- 集团成员数
            ,group_risk_warn_info_cd -- 集团风险预警信号
            ,group_status -- 集团状态
            ,tax_pay_ctzn_idnt -- 税收居民身份
            ,prnt_cust_no -- 母公司客户号
            ,tax_org_type -- 税收机构类别
            ,cust_mgr_name -- 客户经理姓名
            ,cust_mgr_num -- 客户经理编号
            ,create_te -- 创建柜员
            ,create_org -- 创建机构号
            ,init_system_id -- 创建渠道
            ,init_created_ts -- 源系统创建时间
            ,created_ts -- 进入ecif的时间
            ,updated_ts -- 在ecif中失效的时间
            ,last_updated_te -- 最新更新柜员
            ,last_updated_org -- 最新更新机构号
            ,last_system_id -- 最新更新渠道
            ,last_updated_ts -- 最新更新时间
            ,grp_typ -- 
            ,wthr_ghb_assoc_txn -- 
            ,fst_busi -- 
            ,pri_major_main_biz_bus_pct -- 
            ,scd_busi -- 
            ,scd_major_main_biz_bus_pct -- 
            ,third_busi -- 
            ,third_major_main_biz_bus_pct -- 
            ,actl_ctrl_cnt -- 
            ,main_cntri_cnt -- 
            ,upd_offic_loc_date -- 
            ,src_sys_num -- 来源系统编号
            ,last_updated_src_sys_num -- 最新更新源系统编号
            ,actl_ctrl_cert_num -- 实际控制人证件代码
            ,actl_ctrl_iden_typ -- 实际控制人证件类型
            ,actl_ctrl_name -- 实际控制人名称
            ,actl_ctrl_nation_cd -- 实际控制人国别
            ,base_group_cust_no -- 总分行认定集团客户
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
            group_id -- 群体id
            ,group_num -- 集团编号
            ,group_name -- 集团名称
            ,group_short_name -- 集团简称
            ,group_en_name -- 集团英文名称
            ,phys_addr_cty_zone_cd -- 国家和地区
            ,group_work_addr_dist_cd -- 集团办公地行政区划
            ,group_dom_work_addr -- 集团国内办公地址
            ,trade_group_ind -- 同业集团标志
            ,group_mem_cnt -- 集团成员数
            ,group_risk_warn_info_cd -- 集团风险预警信号
            ,group_status -- 集团状态
            ,tax_pay_ctzn_idnt -- 税收居民身份
            ,prnt_cust_no -- 母公司客户号
            ,tax_org_type -- 税收机构类别
            ,cust_mgr_name -- 客户经理姓名
            ,cust_mgr_num -- 客户经理编号
            ,create_te -- 创建柜员
            ,create_org -- 创建机构号
            ,init_system_id -- 创建渠道
            ,init_created_ts -- 源系统创建时间
            ,created_ts -- 进入ecif的时间
            ,updated_ts -- 在ecif中失效的时间
            ,last_updated_te -- 最新更新柜员
            ,last_updated_org -- 最新更新机构号
            ,last_system_id -- 最新更新渠道
            ,last_updated_ts -- 最新更新时间
            ,grp_typ -- 
            ,wthr_ghb_assoc_txn -- 
            ,fst_busi -- 
            ,pri_major_main_biz_bus_pct -- 
            ,scd_busi -- 
            ,scd_major_main_biz_bus_pct -- 
            ,third_busi -- 
            ,third_major_main_biz_bus_pct -- 
            ,actl_ctrl_cnt -- 
            ,main_cntri_cnt -- 
            ,upd_offic_loc_date -- 
            ,src_sys_num -- 来源系统编号
            ,last_updated_src_sys_num -- 最新更新源系统编号
            ,' ' as actl_ctrl_cert_num -- 实际控制人证件代码
            ,' ' as actl_ctrl_iden_typ -- 实际控制人证件类型
            ,' ' as actl_ctrl_name -- 实际控制人名称
            ,' ' as actl_ctrl_nation_cd -- 实际控制人国别
            ,' ' as base_group_cust_no -- 总分行认定集团客户
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
from eifs_t01_corp_group_info_bak${batch_date}
where end_dt = to_date(tb.end_dt,'yyyymmdd');
commit;

end loop;
end;
/
