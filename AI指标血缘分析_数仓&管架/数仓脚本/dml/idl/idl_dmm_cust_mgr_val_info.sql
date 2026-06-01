/*
Purpose:    报表集市层-零售贷款日均余额信息表：包括所有的零售贷款日均余额。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd idl_dmm_cust_mgr_val_info
CreateDate: 20220329
Logs:       20260305 陈伟峰 手工脚本
			20260508 谭钧泽 新增【中收类FTP营业净收入、中收类税金及附加、中收类拨备前利润、中收类营业利润、中收类税前利润、中收类FTP净利润、中收类经济利润(EVA)、中收类RAROC（风险调整后的资本收益率）】字段							

*/

set timing on
-- 0.1 alter parallel
alter session force parallel query parallel 8;
alter session force parallel dml parallel 8;
-- alter seesion force parallel ddl parallel 1;

-- 1.1 drop timeout partition and add partition
whenever sqlerror continue none;
--alter table ${idl_schema}.dmm_cust_mgr_val_info drop partition p_${retain_day};
alter table ${idl_schema}.dmm_cust_mgr_val_info drop partition p_${batch_date};
alter table ${idl_schema}.dmm_cust_mgr_val_info add partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

---- 1.2 create table for exchage and add partition
--whenever sqlerror continue none;
drop table ${idl_schema}.dmm_cust_mgr_val_info_ex purge;


-- 2.1 insert into ex table
whenever sqlerror exit sql.sqlcode;
create table ${idl_schema}.dmm_cust_mgr_val_info_ex
nologging
compress ${option_switch} for query high
as select * from ${idl_schema}.dmm_cust_mgr_val_info where 0=1;

whenever sqlerror exit sql.sqlcode;
insert into ${idl_schema}.dmm_cust_mgr_val_info_ex(
    etl_dt                                   --数据日期
    ,lp_id                                   --法人编号
    ,cust_mgr_id                             --客户经理编号
    ,cust_mgr_name                           --客户经理名称
    ,belong_brch_id                          --所属分行编号
    ,belong_brch_name                        --所属分行名称
    ,belong_subrch_id                        --所属支行编号
    ,belong_subrch_name                      --所属支行名称
    ,retl_loan_bus_inco_thsnds               --零贷营收万元
    ,riches_bus_inco_thsnds                  --财富营收万元
    ,corp_bus_inco_thsnds                    --公司营收万元
    ,ftp_bus_net_inco                        --FTP营业净收入
    ,asset_ftp_bus_net_inco                  --资产端FTP营业净收入
    ,liab_ftp_bus_net_inco                   --负债端FTP营业净收入
	,inter_ftp_bus_net_inco 				 --中收类FTP营业净收入
    ,asset_class_net_int_inco                --资产类净利息收入
    ,liab_class_net_int_inco                 --负债类净利息收入
    ,asset_bus_fee                           --资产端营业费用
    ,liab_bus_fee                            --负债端营业费用
    ,asset_tax_and_addit                     --资产端税金及附加
    ,liab_tax_and_addit                      --负债端税金及附加
	,inter_tax_and_addit                     --中收类税金及附加
    ,asset_before_provi_margin               --资产端拨备前利润
    ,liab_before_provi_margin                --负债端拨备前利润
	,inter_before_provi_margin               --中收类拨备前利润
    ,asset_impam_loss                        --资产减值损失
    ,asset_bus_margin                        --资产端营业利润
    ,liab_bus_margin                         --负债端营业利润
	,inter_bus_margin                        --中收类营业利润
    ,asset_out_bus_net_inco                  --资产端营业外净收入
    ,liab_out_bus_net_inco                   --负债端营业外净收入
    ,asset_pre_tax_margin                    --资产端税前利润
    ,liab_pre_tax_margin                     --负债端税前利润
	,inter_pre_tax_margin                    --中收类税前利润
    ,asset_ftp_net_margin                    --资产端FTP净利润
    ,liab_ftp_net_margin                     --负债端FTP净利润
	,inter_ftp_net_margin                    --中收类FTP净利润
    ,asset_econ_margin_eva                   --资产端经济利润(EVA)
    ,liab_econ_margin_eva                    --负债端经济利润(EVA)
	,inter_econ_margin_eva                   --中收类经济利润(EVA)
    ,asset_raroc                             --资产端RAROC（风险调整后的资本收益率）
    ,liab_raroc                              --负债端RAROC（风险调整后的资本收益率）
    ,inter_raroc                             --中收类RAROC（风险调整后的资本收益率）
	,job_cd                                  --任务代码
    ,etl_timestamp                           --数据处理时间
)
select
    to_date('${batch_date}','yyyymmdd')               --数据日期
    ,'9999'                                              --法人编号
    ,t1.hydh                                             --客户经理编号
    ,t1.hymc                                             --客户经理名称
    ,substr(t5.jgdh,1,3)                              --所属分行编号
    ,t7.org_name                                         --所属分行名称
    ,t6.subrch_id                                        --所属支行编号
    ,t6.subrch_name                                      --所属支行名称
    ,nvl(t3.ljftpjsy,0)                                         --零贷营收万元
    ,nvl(t1.riches_bus_inco_thsnds,0)                           --财富营收万元
    ,nvl(t1.corp_bus_inco_thsnds,0)                             --公司营收万元
    ,nvl(t2.ftp_bus_net_inco,0)                                 --ftp营业净收入
    ,nvl(t2.asset_ftp_bus_net_inco,0)                           --资产端ftp营业净收入
    ,nvl(t2.liab_ftp_bus_net_inco,0)                            --负债端ftp营业净收入
	,nvl(t2.inter_ftp_bus_net_inco,0)                           --中收类ftp营业净收入
    ,nvl(t2.asset_class_net_int_inco,0)                         --资产类净利息收入
    ,nvl(t2.liab_class_net_int_inco,0)                          --负债类净利息收入
    ,nvl(t2.asset_bus_fee,0)                                    --资产端营业费用
    ,nvl(t2.liab_bus_fee,0)                                     --负债端营业费用
    ,nvl(t2.asset_tax_and_addit,0)                              --资产端税金及附加
    ,nvl(t2.liab_tax_and_addit,0)                               --负债端税金及附加
	,nvl(t2.inter_tax_and_addit,0)                              --中收类税金及附加
    ,nvl(t2.asset_before_provi_margin,0)                        --资产端拨备前利润
    ,nvl(t2.liab_before_provi_margin,0)                         --负债端拨备前利润
	,nvl(t2.inter_before_provi_margin,0)                        --中收类拨备前利润
    ,nvl(t2.asset_impam_loss,0)                                 --资产减值损失
    ,nvl(t2.asset_bus_margin,0)                                 --资产端营业利润
    ,nvl(t2.liab_bus_margin,0)                                  --负债端营业利润
	,nvl(t2.inter_bus_margin,0)                                 --中收类营业利润
    ,nvl(t2.asset_out_bus_net_inco,0)                           --资产端营业外净收入
    ,nvl(t2.liab_out_bus_net_inco,0)                            --负债端营业外净收入
    ,nvl(t2.asset_pre_tax_margin,0)                             --资产端税前利润
    ,nvl(t2.liab_pre_tax_margin,0)                              --负债端税前利润
	,nvl(t2.inter_pre_tax_margin,0)                             --中收类税前利润
    ,nvl(t2.asset_ftp_net_margin,0)                             --资产端ftp净利润
    ,nvl(t2.liab_ftp_net_margin,0)                              --负债端ftp净利润
	,nvl(t2.inter_ftp_net_margin,0)                             --中收类ftp净利润
    ,nvl(t2.asset_econ_margin_eva,0)                            --资产端经济利润(eva)
    ,nvl(t2.liab_econ_margin_eva,0)                             --负债端经济利润(eva)
	,nvl(t2.inter_econ_margin_eva,0)                            --中收类经济利润(eva)
    ,nvl(t2.asset_raroc,0)                                      --资产端raroc（风险调整后的资本收益率）
    ,nvl(t2.liab_raroc,0)                                       --负债端raroc（风险调整后的资本收益率）
	,nvl(t2.inter_raroc,0)                                      --中收类raroc（风险调整后的资本收益率）
    ,'pams'                                              --任务代码
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6')   --etl处理时间戳
from (select 
                 t2.hydh
                ,t2.hymc
                ,t1.khdxdh
                ,sum(case when t1.zbdh in('2000867','2000686') then t1.zbz/10000 else 0 end)  as riches_bus_inco_thsnds
                ,sum(case when t1.zbdh in('1000036') then t1.zbz/10000 else 0 end)  as corp_bus_inco_thsnds
         from ${iol_schema}.pams_v_yjzb_hy t1
         inner join ${iol_schema}.pams_khdx_hy t2
           on t1.khdxdh = t2.khdxdh
         and t2.start_dt <=to_date('${batch_date}','yyyymmdd') 
         and t2.end_dt >to_date('${batch_date}','yyyymmdd') 
       where t1.tjrq = '${batch_date}'--统计日期
         and t1.sdbs = 7--时段标识7年累计
         and t1.zbdh in('1000036','2000867','2000686') 
         and t1.bz = '0A'--本外币合计
         and t1.etl_dt =to_date('${batch_date}','yyyymmdd') 
      group by t2.hydh,t2.hymc,t1.khdxdh) t1
left join (select t.cust_mgr_no --客户经理编号 
                                ,SUM(CASE WHEN T.KPI_CODE = 'PA00D005' THEN T.KPI_VALUE_Y END)                                        AS FTP_BUS_NET_INCO                        --FTP营业净收入
         ,SUM(CASE WHEN T.KPI_CODE = 'PA00D005' AND SUBSTR(T.SUBJ_NO,1,1) = '1' THEN T.KPI_VALUE_Y END)    AS ASSET_FTP_BUS_NET_INCO                  --资产端FTP营业净收入
         ,SUM(CASE WHEN T.KPI_CODE = 'PA00D005' AND SUBSTR(T.SUBJ_NO,1,1) = '2' THEN T.KPI_VALUE_Y END)    AS LIAB_FTP_BUS_NET_INCO                   --负债端FTP营业净收入
		 ,SUM(CASE WHEN T.KPI_CODE = 'PA00D005' AND SUBSTR(T.SUBJ_NO,1,1) = '6' THEN T.KPI_VALUE_Y END)    AS INTER_FTP_BUS_NET_INCO
                   --中收类FTP营业净收入
         ,SUM(CASE WHEN T.KPI_CODE = 'PA00D006' AND SUBSTR(T.SUBJ_NO,1,1) = '1' THEN T.KPI_VALUE_Y END)    AS ASSET_CLASS_NET_INT_INCO                --资产类净利息收入
         ,SUM(CASE WHEN T.KPI_CODE = 'PA00D010' AND SUBSTR(T.SUBJ_NO,1,1) = '2' THEN T.KPI_VALUE_Y END)    AS LIAB_CLASS_NET_INT_INCO                 --负债类净利息收入
         ,SUM(CASE WHEN T.KPI_CODE = 'PA00D018' AND SUBSTR(T.SUBJ_NO,1,1) = '1' THEN T.KPI_VALUE_Y END)    AS ASSET_BUS_FEE                           --资产端营业费用
         ,SUM(CASE WHEN T.KPI_CODE = 'PA00D018' AND SUBSTR(T.SUBJ_NO,1,1) = '2' THEN T.KPI_VALUE_Y END)    AS LIAB_BUS_FEE                            --负债端营业费用
         ,SUM(CASE WHEN T.KPI_CODE = 'PA00B036' AND SUBSTR(T.SUBJ_NO,1,1) = '1' THEN T.KPI_VALUE_Y END)    AS ASSET_TAX_AND_ADDIT                     --资产端税金及附加
         ,SUM(CASE WHEN T.KPI_CODE = 'PA00B036' AND SUBSTR(T.SUBJ_NO,1,1) = '2' THEN T.KPI_VALUE_Y END)    AS LIAB_TAX_AND_ADDIT                      --负债端税金及附加
		 ,SUM(CASE WHEN T.KPI_CODE = 'PA00B036' AND SUBSTR(T.SUBJ_NO,1,1) = '6' THEN T.KPI_VALUE_Y END)    AS INTER_TAX_AND_ADDIT                      --中收类税金及附加
         ,SUM(CASE WHEN T.KPI_CODE = 'PA00D017' AND SUBSTR(T.SUBJ_NO,1,1) = '1' THEN T.KPI_VALUE_Y END)    AS ASSET_BEFORE_PROVI_MARGIN               --资产端拨备前利润
         ,SUM(CASE WHEN T.KPI_CODE = 'PA00D017' AND SUBSTR(T.SUBJ_NO,1,1) = '2' THEN T.KPI_VALUE_Y END)    AS LIAB_BEFORE_PROVI_MARGIN                --负债端拨备前利润
		 ,SUM(CASE WHEN T.KPI_CODE = 'PA00D017' AND SUBSTR(T.SUBJ_NO,1,1) = '6' THEN T.KPI_VALUE_Y END)    AS INTER_BEFORE_PROVI_MARGIN
                --中收类拨备前利润
         ,SUM(CASE WHEN T.KPI_CODE = 'PA00D020' THEN T.KPI_VALUE_Y END)                                        AS ASSET_IMPAM_LOSS                        --资产减值损失
         ,SUM(CASE WHEN T.KPI_CODE = 'PA00D019' AND SUBSTR(T.SUBJ_NO,1,1) = '1' THEN T.KPI_VALUE_Y END)    AS ASSET_BUS_MARGIN                        --资产端营业利润
         ,SUM(CASE WHEN T.KPI_CODE = 'PA00D019' AND SUBSTR(T.SUBJ_NO,1,1) = '2' THEN T.KPI_VALUE_Y END)    AS LIAB_BUS_MARGIN                         --负债端营业利润
		 ,SUM(CASE WHEN T.KPI_CODE = 'PA00D019' AND SUBSTR(T.SUBJ_NO,1,1) = '6' THEN T.KPI_VALUE_Y END)    AS INTER_BUS_MARGIN                         --中收类营业利润
         ,SUM(CASE WHEN T.KPI_CODE = 'PA00D022' AND SUBSTR(T.SUBJ_NO,1,1) = '1' THEN T.KPI_VALUE_Y END)    AS ASSET_OUT_BUS_NET_INCO                  --资产端营业外净收入
         ,SUM(CASE WHEN T.KPI_CODE = 'PA00D022' AND SUBSTR(T.SUBJ_NO,1,1) = '2' THEN T.KPI_VALUE_Y END)    AS LIAB_OUT_BUS_NET_INCO                   --负债端营业外净收入
         ,SUM(CASE WHEN T.KPI_CODE = 'PA00D021' AND SUBSTR(T.SUBJ_NO,1,1) = '1' THEN T.KPI_VALUE_Y END)    AS ASSET_PRE_TAX_MARGIN                    --资产端税前利润
         ,SUM(CASE WHEN T.KPI_CODE = 'PA00D021' AND SUBSTR(T.SUBJ_NO,1,1) = '2' THEN T.KPI_VALUE_Y END)    AS LIAB_PRE_TAX_MARGIN                     --负债端税前利润
		 ,SUM(CASE WHEN T.KPI_CODE = 'PA00D021' AND SUBSTR(T.SUBJ_NO,1,1) = '6' THEN T.KPI_VALUE_Y END)    AS INTER_PRE_TAX_MARGIN                     --中收类税前利润
         ,SUM(CASE WHEN T.KPI_CODE = 'PA00D023' AND SUBSTR(T.SUBJ_NO,1,1) = '1' THEN T.KPI_VALUE_Y END)    AS ASSET_FTP_NET_MARGIN                    --资产端FTP净利润
         ,SUM(CASE WHEN T.KPI_CODE = 'PA00D023' AND SUBSTR(T.SUBJ_NO,1,1) = '2' THEN T.KPI_VALUE_Y END)    AS LIAB_FTP_NET_MARGIN                     --负债端FTP净利润
		 ,SUM(CASE WHEN T.KPI_CODE = 'PA00D023' AND SUBSTR(T.SUBJ_NO,1,1) = '6' THEN T.KPI_VALUE_Y END)    AS INTER_FTP_NET_MARGIN                     --中收类FTP净利润
         ,SUM(CASE WHEN T.KPI_CODE = 'PA00D025' AND SUBSTR(T.SUBJ_NO,1,1) = '1' THEN T.KPI_VALUE_Y END)    AS ASSET_ECON_MARGIN_EVA                   --资产端经济利润(EVA)
         ,SUM(CASE WHEN T.KPI_CODE = 'PA00D025' AND SUBSTR(T.SUBJ_NO,1,1) = '2' THEN T.KPI_VALUE_Y END)    AS LIAB_ECON_MARGIN_EVA                    --负债端经济利润(EVA)
		 ,SUM(CASE WHEN T.KPI_CODE = 'PA00D025' AND SUBSTR(T.SUBJ_NO,1,1) = '6' THEN T.KPI_VALUE_Y END)    AS INTER_ECON_MARGIN_EVA                    --中收类经济利润(EVA)
         ,NVL(SUM(CASE WHEN T.KPI_CODE = 'PA00D023' AND SUBSTR(T.SUBJ_NO,1,1) = '1' THEN T.KPI_VALUE_Y END) 
         / NULLIF(SUM(CASE WHEN T.KPI_CODE = 'PA00B044' AND SUBSTR(T.SUBJ_NO,1,1) = '1' THEN T.KPI_VALUE_Y END),0),0) / 273 *365 AS ASSET_RAROC    --资产端RAROC（风险调整后的资本收益率）
         ,NVL(SUM(CASE WHEN T.KPI_CODE = 'PA00D023' AND SUBSTR(T.SUBJ_NO,1,1) = '2' THEN T.KPI_VALUE_Y END) 
         / NULLIF(SUM(CASE WHEN T.KPI_CODE = 'PA00B044' AND SUBSTR(T.SUBJ_NO,1,1) = '2' THEN T.KPI_VALUE_Y END),0),0) / 273 *365 AS LIAB_RAROC     --负债端RAROC（风险调整后的资本收益率）
		 ,NVL(SUM(CASE WHEN T.KPI_CODE = 'PA00D023' AND SUBSTR(T.SUBJ_NO,1,1) = '6' THEN T.KPI_VALUE_Y END) 
         / NULLIF(SUM(CASE WHEN T.KPI_CODE = 'PA00B044' AND SUBSTR(T.SUBJ_NO,1,1) = '6' THEN T.KPI_VALUE_Y END),0),0) / 273 *365 AS INTER_RAROC     --中收类RAROC（风险调整后的资本收益率）
              from ${iol_schema}.cass_p_fsi_kpi t
              where t.etl_dt =to_date('${batch_date}','yyyymmdd') 
              and nvl(trim(t.cost_type),'TOTAL_COST') = 'TOTAL_COST'  --限定成本分摊费用为全成本分摊
              and t.adjust_type = 'BF'  --取调整前
              and t.kpi_code in ('PA00D005','PA00D006','PA00D010','PA00D018','PA00B036','PA00D017','PA00D020','PA00D019','PA00D022','PA00D021','PA00D023','PA00D025','PA00B044')  --限定指标
              and trim(t.cust_mgr_no) is not null --排除客户经理为空数据
              and t.com_line = '2'  --限定零售条线，1：对公，2：零售，3：同业
              group by t.cust_mgr_no
              ) t2
  on t1.hydh = t2.cust_mgr_no
left join (select khjlgh,sum(ljftpjsy) as ljftpjsy 
                 from ${iol_schema}.pams_jxbb_dkftpmx t3 
                where etl_dt =to_date('${batch_date}','yyyymmdd') 
                group by khjlgh)t3
  on t1.hydh = t3.khjlgh
left join ${iol_schema}.pams_khdx_jgcy t4
  on t1.hydh=t4.hydh
and t4.start_dt <= to_date('${batch_date}','yyyymmdd')
and t4.end_dt > to_date('${batch_date}','yyyymmdd')
and t4.qsrq <='${batch_date}'  
and t4.jsrq >'${batch_date}'
left join ${iol_schema}.pams_khdx_jg t5
  on t5.khdxdh=t4.jgkhdxdh
and t5.start_dt <= to_date('${batch_date}','yyyymmdd')
and t5.end_dt > to_date('${batch_date}','yyyymmdd')
left join (select t1.org_id                                                 -- 机构编号
                      ,case when t83.org_type_cd = '12' then t81.org_id
                              when t1.org_type_cd = '12' then t1.org_id
                              else null end as subrch_id                     -- 支行编号
                      ,case when t83.org_type_cd = '12' then t82.org_name
                              when t1.org_type_cd = '12' then t1.org_name
                              else null end as subrch_name                   -- 支行名称
                 from ${iml_schema}.org_int_org t1
                 left join ${iml_schema}.org_int_org_rela_h t8
                   on t1.org_id=t8.org_id
                  and t8.org_rela_type_cd = '01'
                  and t8.start_dt <= to_date('${batch_date}','yyyymmdd')
                  and t8.end_dt > to_date('${batch_date}','yyyymmdd')
                  and t8.job_cd = 'uussf1'
                 left join ${iml_schema}.org_int_org_rela_h t81
                   on t8.rela_org_id = t81.org_id
                  and t81.org_rela_type_cd = '01'
                  and t81.start_dt <= to_date('${batch_date}','yyyymmdd')
                  and t81.end_dt > to_date('${batch_date}','yyyymmdd')
                  and t81.job_cd = 'uussf1'
                 left join ${iml_schema}.org_intnal_org_name_h t82
                   on t81.org_id = t82.org_id
                  and t82.start_dt <= to_date('${batch_date}','yyyymmdd')
                  and t82.end_dt > to_date('${batch_date}','yyyymmdd')
                  and t82.job_cd = 'uussf1'
                 left join ${iml_schema}.org_int_org t83
                   on t81.org_id = t83.org_id
                  and t83.create_dt <= to_date('${batch_date}','yyyymmdd')
                  and t83.job_cd = 'uussf1'
                  and t83.id_mark <> 'D'
                where t1.create_dt <= to_date('${batch_date}','yyyymmdd')
                  and t1.job_cd = 'uussf1'
                  and t1.id_mark <> 'D'
               )T6
on t5.jgdh=t6.org_id
left join ${iml_schema}.org_int_org t7
  on substr(t5.jgdh,1,3)=t7.org_id
 and t7.create_dt <= to_date('${batch_date}','yyyymmdd')
 and t7.job_cd = 'uussf1'
 and t7.id_mark <> 'D'
where 1=1;
commit;

-- 2.2 exchage ex table and target table
alter table ${idl_schema}.dmm_cust_mgr_val_info exchange partition p_${batch_date} with table ${idl_schema}.dmm_cust_mgr_val_info_ex;

-- 3.1 drop ex table
drop table ${idl_schema}.dmm_cust_mgr_val_info_ex purge;
--drop table ${idl_schema}.tmp_dmm_cust_mgr_val_info_01 purge;
--drop table ${idl_schema}.tmp_dmm_cust_mgr_val_info_02 purge;

-- 3.2 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${idl_schema}',tabname => 'dmm_cust_mgr_val_info', partname => 'p_${batch_date}', granularity => 'PARTITION', degree => 8, cascade => true);
