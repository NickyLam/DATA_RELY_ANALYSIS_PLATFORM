/*
Purpose:    IDL-指标事实表
Creater:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd idl_mc_index_fact_cas
CreateDate: None
FileType:   DML
Logs:
    表英文名： mc_index_fact
    表中文名： 指标事实表
    创建日期： None
    主键字段： 数据日期
    归属层次： IDL
    归属主题： None
    分区粒度： 
    分析人员： None
    时间粒度： 日
    保留周期： 永久
    描述信息： None
    更新记录:
        2024-12-03    郑沛隆    新建脚本    
                    
*/


--设置参数
set timing on
-- 0.1 alter parallel
alter session force parallel query parallel 8;
alter session force parallel dml parallel 8;
-- 1.1 create table for exchage
whenever sqlerror continue none;
alter table ${idl_schema}.mc_index_fact add partition p_${last_month_end} values (to_date('${last_month_end}','yyyymmdd'))(subpartition p_${last_month_end}_cas values ('CAS'));
alter table ${idl_schema}.mc_index_fact modify partition p_${last_month_end} add subpartition p_${last_month_end}_cas values ('CAS');
alter table ${idl_schema}.mc_index_fact truncate subpartition p_${last_month_end}_cas;

whenever sqlerror exit sql.sqlcode; 

/*==============第1组==============*/

--汇总指标事实表:三级指标-支行团队
whenever sqlerror continue none;
drop table ${idl_schema}.tmp_mc_index_fact_cas_01 purge;
whenever sqlerror exit sql.sqlcode;
create table ${idl_schema}.tmp_mc_index_fact_cas_01
as
select
    to_date('${last_month_end}','yyyymmdd') as etl_dt                --None
    ,t2.CURR_CD as curr_cd                                       --币种
    ,t2.CURR_NAME as curr_name                                   --币种名称
    ,t1.index_no_mcs as index_no                                 --管驾指标编号
    ,t1.index_name_mcs as index_name                             --管驾指标名称
    -- 5
    ,t2.MANAGER_ORG as manager_org                               --考核机构
    ,t2.MANAGER_ORG_NAME as manager_org_name                     --考核机构名称
    ,case when t1.UNIT ='%' and sum(t2.KPI_VALUE_YOY)>0 then SUM(T2.KPI_VALUE_YY)/SUM(t2.KPI_VALUE_YOY)/(to_date('${last_month_end}','yyyymmdd')-decode(substr('${last_month_end}',5,4),'1231',to_date('${last_year_start}','yyyymmdd'),to_date('${year_start}','yyyymmdd'))+1)*(add_months(trunc(to_date('${last_month_end}','yyyymmdd'),'yyyy'),12)-trunc(to_date('${last_month_end}','yyyymmdd'),'yyyy'))
     when t1.UNIT ='%' and sum(t2.KPI_VALUE_YOY)=0 then 0
     else SUM(t2.KPI_VALUE_Y)
end as kpi_value_y --当年值
    ,case when t1.UNIT ='%' and sum(t2.KPI_VALUE_MOM)>0 then SUM(T2.KPI_VALUE_MM)/SUM(t2.KPI_VALUE_MOM)/extract(day from last_day(to_date('${last_month_end}','yyyymmdd')))*(add_months(trunc(to_date('${last_month_end}','yyyymmdd'),'yyyy'),12)-trunc(to_date('${last_month_end}','yyyymmdd'),'yyyy'))
     when t1.UNIT ='%' and sum(t2.KPI_VALUE_MOM)=0 then 0
     else SUM(t2.KPI_VALUE_M)
end as kpi_value_m --当月值
    ,t1.UNIT as ind_unit                                         --None
    -- 10
 from mc_index_define t1 --指标定义表 
INNER JOIN itl_edw_cass_R_RPT_RST0015 t2 --报表-管驾明细表 
 on t2.etl_dt=to_date('${last_month_end}','yyyymmdd')
and t2.index_level3_class = t1.index_name_mcs
--and t2.index_level1_class = t1.index_clsaa_s_mcs
--and t2.index_level2_class = t1.index_clsaa_t_mcs
and length(t2.MANAGER_ORG)>3
and t2.MANAGER_ORG<>'000000'
where t1.source_system='数仓-管会'
and substr(t1.index_no_mcs,length(t1.index_no_mcs)-1,2)<>'00' --三级指标
GROUP BY t2.CURR_CD
,t2.CURR_NAME
,t1.index_no_mcs
,t1.index_name_mcs
,t2.MANAGER_ORG
,t2.MANAGER_ORG_NAME
,t1.UNIT;
commit;


/*==============第2组==============*/

--汇总指标事实表:二级指标-支行团队
insert into ${idl_schema}.tmp_mc_index_fact_cas_01(
    etl_dt                                                       --数据日期
    ,curr_cd                                                     --币种
    ,curr_name                                                   --币种名称
    ,index_no                                                    --指标编号
    ,index_name                                                  --指标名称
    -- 5
    ,manager_org                                                 --考核机构
    ,manager_org_name                                            --考核机构名称
    ,kpi_value_y                                                 --当年值
    ,kpi_value_m                                                 --当月值
    ,ind_unit                                                    --指标单位
    -- 10
)
select
    to_date('${last_month_end}','yyyymmdd') as etl_dt                --None
    ,t2.CURR_CD as curr_cd                                       --币种
    ,t2.CURR_NAME as curr_name                                   --币种名称
    ,t1.index_no_mcs as index_no                                 --管驾指标编号
    ,t1.index_name_mcs as index_name                             --管驾指标名称
    -- 5
    ,t2.MANAGER_ORG as manager_org                               --考核机构
    ,t2.MANAGER_ORG_NAME as manager_org_name                     --考核机构名称
     ,case when t1.UNIT ='%' then nvl(max(t3.kpi_value_y_dk),0)-nvl(max(t4.kpi_value_y_ck),0)
     else SUM(t2.KPI_VALUE_Y)
     end as kpi_value_y --当年值
    ,case when t1.UNIT ='%'  then nvl(max(t3.kpi_value_m_dk),0)-nvl(max(t4.kpi_value_m_ck),0)
     else SUM(t2.KPI_VALUE_M)
     end as kpi_value_m --当月值
    ,t1.UNIT as ind_unit                                         --None
    -- 10
 from mc_index_define t1 --指标定义表 
INNER JOIN itl_edw_cass_R_RPT_RST0015 t2 --报表-管驾明细表 
 on t2.etl_dt=to_date('${last_month_end}','yyyymmdd')
and t2.index_level1_class = t1.index_clsaa_s_mcs
and t2.index_level2_class = t1.index_clsaa_t_mcs
and length(t2.MANAGER_ORG)>3
and t2.MANAGER_ORG<>'000000'
left JOIN (select case when SUM(t31.KPI_VALUE_MOM)=0 then 0 else SUM(t31.KPI_VALUE_MM)/SUM(t31.KPI_VALUE_MOM)/extract(day from last_day(to_date('${last_month_end}','yyyymmdd')))*(add_months(trunc(to_date('${last_month_end}','yyyymmdd'),'yyyy'),12)-trunc(to_date('${last_month_end}','yyyymmdd'),'yyyy')) end as kpi_value_m_dk
                 ,case when SUM(t31.KPI_VALUE_YOY)=0 then 0 else SUM(t31.KPI_VALUE_YY)/SUM(t31.KPI_VALUE_YOY)/(to_date('${last_month_end}','yyyymmdd')-decode(substr('${last_month_end}',5,4),'1231',to_date('${last_year_start}','yyyymmdd'),to_date('${year_start}','yyyymmdd'))+1)*(add_months(trunc(to_date('${last_month_end}','yyyymmdd'),'yyyy'),12)-trunc(to_date('${last_month_end}','yyyymmdd'),'yyyy')) end as kpi_value_y_dk
                 ,t31.CURR_CD,t31.index_level2_class,t31.MANAGER_ORG
                from itl_edw_cass_R_RPT_RST0015 t31 --报表-管驾明细表 
               where t31.etl_dt=to_date('${last_month_end}','yyyymmdd')
                and t31.index_level1_class = '存贷利差'            
                and length(t31.MANAGER_ORG)>3
                and t31.MANAGER_ORG<>'000000'
                and substr(t31.COM_LINE_NAME,length(t31.COM_LINE_NAME)-1)='贷款'
                group by t31.CURR_CD,t31.index_level2_class,t31.MANAGER_ORG) t3
  on  t3.CURR_CD = t2.CURR_CD
  and t3.index_level2_class = t1.index_clsaa_t_mcs
  and t3.MANAGER_ORG=t2.MANAGER_ORG
left JOIN (select case when SUM(t41.KPI_VALUE_MOM)=0 then 0 else SUM(t41.KPI_VALUE_MM)/SUM(t41.KPI_VALUE_MOM)/extract(day from last_day(to_date('${last_month_end}','yyyymmdd')))*(add_months(trunc(to_date('${last_month_end}','yyyymmdd'),'yyyy'),12)-trunc(to_date('${last_month_end}','yyyymmdd'),'yyyy')) end as kpi_value_m_ck
                 ,case when SUM(t41.KPI_VALUE_YOY)=0 then 0 else SUM(t41.KPI_VALUE_YY)/SUM(t41.KPI_VALUE_YOY)/(to_date('${last_month_end}','yyyymmdd')-decode(substr('${last_month_end}',5,4),'1231',to_date('${last_year_start}','yyyymmdd'),to_date('${year_start}','yyyymmdd'))+1)*(add_months(trunc(to_date('${last_month_end}','yyyymmdd'),'yyyy'),12)-trunc(to_date('${last_month_end}','yyyymmdd'),'yyyy')) end as kpi_value_y_ck
                 ,t41.CURR_CD,t41.index_level2_class,t41.MANAGER_ORG
                from itl_edw_cass_R_RPT_RST0015 t41 --报表-管驾明细表 
               where t41.etl_dt=to_date('${last_month_end}','yyyymmdd')
                and t41.index_level1_class = '存贷利差'            
                and length(t41.MANAGER_ORG)>3
                and t41.MANAGER_ORG<>'000000'
                and substr(t41.COM_LINE_NAME,length(t41.COM_LINE_NAME)-1)='存款'
                group by t41.CURR_CD,t41.index_level2_class,t41.MANAGER_ORG) t4
  on  t4.CURR_CD = t2.CURR_CD
  and t4.index_level2_class = t1.index_clsaa_t_mcs
  and t4.MANAGER_ORG=t2.MANAGER_ORG
where t1.source_system='数仓-管会'
and substr(t1.index_no_mcs,length(t1.index_no_mcs)-1,2)='00'
and substr(t1.index_no_mcs,length(t1.index_no_mcs)-4,2)<>'00' --二级指标
GROUP BY t2.CURR_CD
,t2.CURR_NAME
,t1.index_no_mcs
,t1.index_name_mcs
,t2.MANAGER_ORG
,t2.MANAGER_ORG_NAME
,t1.UNIT;
commit;


/*==============第3组==============*/

--汇总指标事实表:一级指标-支行团队
insert into ${idl_schema}.tmp_mc_index_fact_cas_01(
    etl_dt                                                       --数据日期
    ,curr_cd                                                     --币种
    ,curr_name                                                   --币种名称
    ,index_no                                                    --指标编号
    ,index_name                                                  --指标名称
    -- 5
    ,manager_org                                                 --考核机构
    ,manager_org_name                                            --考核机构名称
    ,kpi_value_y                                                 --当年值
    ,kpi_value_m                                                 --当月值
    ,ind_unit                                                    --指标单位
    -- 10
)
select
    to_date('${last_month_end}','yyyymmdd') as etl_dt                --None
    ,t2.CURR_CD as curr_cd                                       --币种
    ,t2.CURR_NAME as curr_name                                   --币种名称
    ,t1.index_no_mcs as index_no                                 --管驾指标编号
    ,t1.index_name_mcs as index_name                             --管驾指标名称
    -- 5
    ,t2.MANAGER_ORG as manager_org                               --考核机构
    ,t2.MANAGER_ORG_NAME as manager_org_name                     --考核机构名称
    ,case when t1.UNIT ='%'  then nvl(max(t3.kpi_value_y_dk),0)-nvl(max(t4.kpi_value_y_ck),0)
     else SUM(t2.KPI_VALUE_Y)
     end as kpi_value_y --当年值
    ,case when t1.UNIT ='%'  then nvl(max(t3.kpi_value_m_dk),0)-nvl(max(t4.kpi_value_m_ck),0)
     else SUM(t2.KPI_VALUE_M)
     end as kpi_value_m --当月值
    ,t1.UNIT as ind_unit                                         --None
    -- 10
 from mc_index_define t1 --指标定义表 
INNER JOIN itl_edw_cass_R_RPT_RST0015 t2 --报表-管驾明细表 
 on t2.etl_dt=to_date('${last_month_end}','yyyymmdd')
and t2.index_level1_class = t1.index_clsaa_s_mcs
and length(t2.MANAGER_ORG)>3
and t2.MANAGER_ORG<>'000000'
left JOIN (select case when SUM(t31.KPI_VALUE_MOM)=0 then 0 else SUM(t31.KPI_VALUE_MM)/SUM(t31.KPI_VALUE_MOM)/extract(day from last_day(to_date('${last_month_end}','yyyymmdd')))*(add_months(trunc(to_date('${last_month_end}','yyyymmdd'),'yyyy'),12)-trunc(to_date('${last_month_end}','yyyymmdd'),'yyyy')) end as kpi_value_m_dk
                 ,case when SUM(t31.KPI_VALUE_YOY)=0 then 0 else SUM(t31.KPI_VALUE_YY)/SUM(t31.KPI_VALUE_YOY)/(to_date('${last_month_end}','yyyymmdd')-decode(substr('${last_month_end}',5,4),'1231',to_date('${last_year_start}','yyyymmdd'),to_date('${year_start}','yyyymmdd'))+1)*(add_months(trunc(to_date('${last_month_end}','yyyymmdd'),'yyyy'),12)-trunc(to_date('${last_month_end}','yyyymmdd'),'yyyy')) end as kpi_value_y_dk
                 ,t31.CURR_CD,t31.MANAGER_ORG
                from itl_edw_cass_R_RPT_RST0015 t31 --报表-管驾明细表 
               where t31.etl_dt=to_date('${last_month_end}','yyyymmdd')
                and t31.index_level1_class = '存贷利差'            
                and length(t31.MANAGER_ORG)>3
                and t31.MANAGER_ORG<>'000000'
                and substr(t31.COM_LINE_NAME,length(t31.COM_LINE_NAME)-1)='贷款'
                and trim(t31.index_level2_class) is null
                group by t31.CURR_CD,t31.MANAGER_ORG) t3
  on  t3.CURR_CD = t2.CURR_CD
  and t3.MANAGER_ORG=t2.MANAGER_ORG
left JOIN (select case when SUM(t41.KPI_VALUE_MOM)=0 then 0 else SUM(t41.KPI_VALUE_MM)/SUM(t41.KPI_VALUE_MOM)/extract(day from last_day(to_date('${last_month_end}','yyyymmdd')))*(add_months(trunc(to_date('${last_month_end}','yyyymmdd'),'yyyy'),12)-trunc(to_date('${last_month_end}','yyyymmdd'),'yyyy')) end as kpi_value_m_ck
                 ,case when SUM(t41.KPI_VALUE_YOY)=0 then 0 else SUM(t41.KPI_VALUE_YY)/SUM(t41.KPI_VALUE_YOY)/(to_date('${last_month_end}','yyyymmdd')-decode(substr('${last_month_end}',5,4),'1231',to_date('${last_year_start}','yyyymmdd'),to_date('${year_start}','yyyymmdd'))+1)*(add_months(trunc(to_date('${last_month_end}','yyyymmdd'),'yyyy'),12)-trunc(to_date('${last_month_end}','yyyymmdd'),'yyyy')) end as kpi_value_y_ck
                 ,t41.CURR_CD,t41.MANAGER_ORG
                from itl_edw_cass_R_RPT_RST0015 t41 --报表-管驾明细表 
               where t41.etl_dt=to_date('${last_month_end}','yyyymmdd')
                and t41.index_level1_class = '存贷利差'            
                and length(t41.MANAGER_ORG)>3
                and t41.MANAGER_ORG<>'000000'
                and substr(t41.COM_LINE_NAME,length(t41.COM_LINE_NAME)-1)='存款'
               and trim(t41.index_level2_class) is null
                group by t41.CURR_CD,t41.MANAGER_ORG) t4
  on  t4.CURR_CD = t2.CURR_CD
  and t4.MANAGER_ORG=t2.MANAGER_ORG
where t1.source_system='数仓-管会'
and substr(t1.index_no_mcs,length(t1.index_no_mcs)-3,4)='0000' --一级指标
GROUP BY t2.CURR_CD
,t2.CURR_NAME
,t1.index_no_mcs
,t1.index_name_mcs
,t2.MANAGER_ORG
,t2.MANAGER_ORG_NAME
,t1.UNIT;
commit;

/*==============第4组==============*/

--汇总指标事实表:三级指标-分行
insert into ${idl_schema}.tmp_mc_index_fact_cas_01(
    etl_dt                                                       --数据日期
    ,curr_cd                                                     --币种
    ,curr_name                                                   --币种名称
    ,index_no                                                    --指标编号
    ,index_name                                                  --指标名称
    -- 5
    ,manager_org                                                 --考核机构
    ,manager_org_name                                            --考核机构名称
    ,kpi_value_y                                                 --当年值
    ,kpi_value_m                                                 --当月值
    ,ind_unit                                                    --指标单位
    -- 10
)
select
    to_date('${last_month_end}','yyyymmdd') as etl_dt                --None
    ,t2.CURR_CD as curr_cd                                       --币种
    ,t2.CURR_NAME as curr_name                                   --币种名称
    ,t1.index_no_mcs as index_no                                 --管驾指标编号
    ,t1.index_name_mcs as index_name                             --管驾指标名称
    -- 5
    ,substr(t2.MANAGER_ORG,1,3) as manager_org                   --考核机构
    ,t3.ORG_NAME as manager_org_name                             --考核机构名称
    ,case when t1.UNIT ='%' and sum(t2.KPI_VALUE_YOY)>0 then SUM(T2.KPI_VALUE_YY)/SUM(t2.KPI_VALUE_YOY)/(to_date('${last_month_end}','yyyymmdd')-decode(substr('${last_month_end}',5,4),'1231',to_date('${last_year_start}','yyyymmdd'),to_date('${year_start}','yyyymmdd'))+1)*(add_months(trunc(to_date('${last_month_end}','yyyymmdd'),'yyyy'),12)-trunc(to_date('${last_month_end}','yyyymmdd'),'yyyy'))
     when t1.UNIT ='%' and sum(t2.KPI_VALUE_YOY)=0 then 0
     else SUM(t2.KPI_VALUE_Y)
end as kpi_value_y --当年值
    ,case when t1.UNIT ='%' and sum(t2.KPI_VALUE_MOM)>0 then SUM(T2.KPI_VALUE_MM)/SUM(t2.KPI_VALUE_MOM)/extract(day from last_day(to_date('${last_month_end}','yyyymmdd')))*(add_months(trunc(to_date('${last_month_end}','yyyymmdd'),'yyyy'),12)-trunc(to_date('${last_month_end}','yyyymmdd'),'yyyy'))
     when t1.UNIT ='%' and sum(t2.KPI_VALUE_MOM)=0 then 0
     else SUM(t2.KPI_VALUE_M)
end as kpi_value_m --当月值
    ,t1.UNIT as ind_unit                                         --None
    -- 10
 from mc_index_define t1 --指标定义表 
INNER JOIN itl_edw_cass_R_RPT_RST0015 t2 --报表-管驾明细表 
 on t2.etl_dt=to_date('${last_month_end}','yyyymmdd')
and t2.index_level3_class = t1.index_name_mcs
--and t2.index_level1_class = t1.index_clsaa_s_mcs
--and t2.index_level2_class = t1.index_clsaa_t_mcs
LEFT JOIN mtl_cmm_intnal_org_info t3 --None 
 on t3.etl_dt=to_date('${last_month_end}','yyyymmdd')
and t3.ORG_ID=substr(t2.MANAGER_ORG,1,3)
where t1.source_system='数仓-管会'
and substr(t1.index_no_mcs,length(t1.index_no_mcs)-1,2)<>'00' --三级指标
GROUP BY t2.CURR_CD
,t2.CURR_NAME
,t1.index_no_mcs
,t1.index_name_mcs
,substr(t2.MANAGER_ORG,1,3)
,t3.ORG_NAME
,t1.UNIT;
commit;


/*==============第5组==============*/

--汇总指标事实表:二级指标-分行
insert into ${idl_schema}.tmp_mc_index_fact_cas_01(
    etl_dt                                                       --数据日期
    ,curr_cd                                                     --币种
    ,curr_name                                                   --币种名称
    ,index_no                                                    --指标编号
    ,index_name                                                  --指标名称
    -- 5
    ,manager_org                                                 --考核机构
    ,manager_org_name                                            --考核机构名称
    ,kpi_value_y                                                 --当年值
    ,kpi_value_m                                                 --当月值
    ,ind_unit                                                    --指标单位
    -- 10
)
select
    to_date('${last_month_end}','yyyymmdd') as etl_dt                --None
    ,t2.CURR_CD as curr_cd                                       --币种
    ,t2.CURR_NAME as curr_name                                   --币种名称
    ,t1.index_no_mcs as index_no                                 --管驾指标编号
    ,t1.index_name_mcs as index_name                             --管驾指标名称
    -- 5
    ,substr(t2.MANAGER_ORG,1,3) as manager_org                   --考核机构
    ,t5.ORG_NAME as manager_org_name                             --考核机构名称
		,case when t1.UNIT ='%'  then nvl(max(t3.kpi_value_y_dk),0)-nvl(max(t4.kpi_value_y_ck),0)
     else SUM(t2.KPI_VALUE_Y)
     end as kpi_value_y --当年值
    ,case when t1.UNIT ='%'  then nvl(max(t3.kpi_value_m_dk),0)-nvl(max(t4.kpi_value_m_ck),0)
     else SUM(t2.KPI_VALUE_M)
     end as kpi_value_m --当月值
    ,t1.UNIT as ind_unit                                         --None
    -- 10
 from mc_index_define t1 --指标定义表 
INNER JOIN itl_edw_cass_R_RPT_RST0015 t2 --报表-管驾明细表 
 on t2.etl_dt=to_date('${last_month_end}','yyyymmdd')
and t2.index_level1_class = t1.index_clsaa_s_mcs
and t2.index_level2_class = t1.index_clsaa_t_mcs
left JOIN (select case when SUM(t31.KPI_VALUE_MOM)=0 then 0 else SUM(t31.KPI_VALUE_MM)/SUM(t31.KPI_VALUE_MOM)/extract(day from last_day(to_date('${last_month_end}','yyyymmdd')))*(add_months(trunc(to_date('${last_month_end}','yyyymmdd'),'yyyy'),12)-trunc(to_date('${last_month_end}','yyyymmdd'),'yyyy')) end as kpi_value_m_dk
                 ,case when SUM(t31.KPI_VALUE_YOY)=0 then 0 else SUM(t31.KPI_VALUE_YY)/SUM(t31.KPI_VALUE_YOY)/(to_date('${last_month_end}','yyyymmdd')-decode(substr('${last_month_end}',5,4),'1231',to_date('${last_year_start}','yyyymmdd'),to_date('${year_start}','yyyymmdd'))+1)*(add_months(trunc(to_date('${last_month_end}','yyyymmdd'),'yyyy'),12)-trunc(to_date('${last_month_end}','yyyymmdd'),'yyyy')) end as kpi_value_y_dk
                 ,t31.CURR_CD,t31.index_level2_class,substr(t31.MANAGER_ORG,1,3) as MANAGER_ORG
                from itl_edw_cass_R_RPT_RST0015 t31 --报表-管驾明细表 
               where t31.etl_dt=to_date('${last_month_end}','yyyymmdd')
                and t31.index_level1_class = '存贷利差'            
                and substr(t31.COM_LINE_NAME,length(t31.COM_LINE_NAME)-1)='贷款'
                group by t31.CURR_CD,t31.index_level2_class,substr(t31.MANAGER_ORG,1,3)) t3
  on  t3.CURR_CD = t2.CURR_CD
  and t3.index_level2_class = t1.index_clsaa_t_mcs
  and t3.MANAGER_ORG=substr(t2.MANAGER_ORG,1,3)
left JOIN (select case when SUM(t41.KPI_VALUE_MOM)=0 then 0 else SUM(t41.KPI_VALUE_MM)/SUM(t41.KPI_VALUE_MOM)/extract(day from last_day(to_date('${last_month_end}','yyyymmdd')))*(add_months(trunc(to_date('${last_month_end}','yyyymmdd'),'yyyy'),12)-trunc(to_date('${last_month_end}','yyyymmdd'),'yyyy')) end as kpi_value_m_ck
                 ,case when SUM(t41.KPI_VALUE_YOY)=0 then 0 else SUM(t41.KPI_VALUE_YY)/SUM(t41.KPI_VALUE_YOY)/(to_date('${last_month_end}','yyyymmdd')-decode(substr('${last_month_end}',5,4),'1231',to_date('${last_year_start}','yyyymmdd'),to_date('${year_start}','yyyymmdd'))+1)*(add_months(trunc(to_date('${last_month_end}','yyyymmdd'),'yyyy'),12)-trunc(to_date('${last_month_end}','yyyymmdd'),'yyyy')) end as kpi_value_y_ck
                 ,t41.CURR_CD,t41.index_level2_class,substr(t41.MANAGER_ORG,1,3) as MANAGER_ORG
                from itl_edw_cass_R_RPT_RST0015 t41 --报表-管驾明细表 
               where t41.etl_dt=to_date('${last_month_end}','yyyymmdd')
                and t41.index_level1_class = '存贷利差'            
                and substr(t41.COM_LINE_NAME,length(t41.COM_LINE_NAME)-1)='存款'
                group by t41.CURR_CD,t41.index_level2_class,substr(t41.MANAGER_ORG,1,3) )t4
  on  t4.CURR_CD = t2.CURR_CD
  and t4.index_level2_class = t1.index_clsaa_t_mcs
  and t4.MANAGER_ORG=substr(t2.MANAGER_ORG,1,3)
LEFT JOIN mtl_cmm_intnal_org_info t5 --None 
 on t5.etl_dt=to_date('${last_month_end}','yyyymmdd')
and t5.ORG_ID=substr(t2.MANAGER_ORG,1,3)
where t1.source_system='数仓-管会'
and substr(t1.index_no_mcs,length(t1.index_no_mcs)-1,2)='00'
and substr(t1.index_no_mcs,length(t1.index_no_mcs)-4,2)<>'00' --二级指标
GROUP BY t2.CURR_CD
,t2.CURR_NAME
,t1.index_no_mcs
,t1.index_name_mcs
,substr(t2.MANAGER_ORG,1,3)
,t5.ORG_NAME
,t1.UNIT;
commit;

/*==============第6组==============*/

--汇总指标事实表:一级指标-分行
insert into ${idl_schema}.tmp_mc_index_fact_cas_01(
    etl_dt                                                       --数据日期
    ,curr_cd                                                     --币种
    ,curr_name                                                   --币种名称
    ,index_no                                                    --指标编号
    ,index_name                                                  --指标名称
    -- 5
    ,manager_org                                                 --考核机构
    ,manager_org_name                                            --考核机构名称
    ,kpi_value_y                                                 --当年值
    ,kpi_value_m                                                 --当月值
    ,ind_unit                                                    --指标单位
    -- 10
)
select
    to_date('${last_month_end}','yyyymmdd') as etl_dt                --None
    ,t2.CURR_CD as curr_cd                                       --币种
    ,t2.CURR_NAME as curr_name                                   --币种名称
    ,t1.index_no_mcs as index_no                                 --管驾指标编号
    ,t1.index_name_mcs as index_name                             --管驾指标名称
    -- 5
    ,substr(t2.MANAGER_ORG,1,3) as manager_org                   --考核机构
    ,t5.ORG_NAME as manager_org_name                             --考核机构名称
   	,case when t1.UNIT ='%'  then nvl(max(t3.kpi_value_y_dk),0)-nvl(max(t4.kpi_value_y_ck),0)
     else SUM(t2.KPI_VALUE_Y)
     end as kpi_value_y --当年值
    ,case when t1.UNIT ='%'  then nvl(max(t3.kpi_value_m_dk),0)-nvl(max(t4.kpi_value_m_ck),0)
     else SUM(t2.KPI_VALUE_M)
     end as kpi_value_m --当月值
    ,t1.UNIT as ind_unit                                         --None
    -- 10
 from mc_index_define t1 --指标定义表 
INNER JOIN itl_edw_cass_R_RPT_RST0015 t2 --报表-管驾明细表 
 on t2.etl_dt=to_date('${last_month_end}','yyyymmdd')
and t2.index_level1_class = t1.index_clsaa_s_mcs
left JOIN (select case when SUM(t31.KPI_VALUE_MOM)=0 then 0 else SUM(t31.KPI_VALUE_MM)/SUM(t31.KPI_VALUE_MOM)/extract(day from last_day(to_date('${last_month_end}','yyyymmdd')))*(add_months(trunc(to_date('${last_month_end}','yyyymmdd'),'yyyy'),12)-trunc(to_date('${last_month_end}','yyyymmdd'),'yyyy')) end as kpi_value_m_dk
                 ,case when SUM(t31.KPI_VALUE_YOY)=0 then 0 else SUM(t31.KPI_VALUE_YY)/SUM(t31.KPI_VALUE_YOY)/(to_date('${last_month_end}','yyyymmdd')-decode(substr('${last_month_end}',5,4),'1231',to_date('${last_year_start}','yyyymmdd'),to_date('${year_start}','yyyymmdd'))+1)*(add_months(trunc(to_date('${last_month_end}','yyyymmdd'),'yyyy'),12)-trunc(to_date('${last_month_end}','yyyymmdd'),'yyyy')) end as kpi_value_y_dk
                 ,t31.CURR_CD,substr(t31.MANAGER_ORG,1,3) as MANAGER_ORG
                from itl_edw_cass_R_RPT_RST0015 t31 --报表-管驾明细表 
               where t31.etl_dt=to_date('${last_month_end}','yyyymmdd')
                and t31.index_level1_class = '存贷利差'            
                and substr(t31.COM_LINE_NAME,length(t31.COM_LINE_NAME)-1)='贷款'
                and trim(t31.index_level2_class) is null
                group by t31.CURR_CD,substr(t31.MANAGER_ORG,1,3)) t3
  on  t3.CURR_CD = t2.CURR_CD
  and t3.MANAGER_ORG=substr(t2.MANAGER_ORG,1,3)
left JOIN (select case when SUM(t41.KPI_VALUE_MOM)=0 then 0 else SUM(t41.KPI_VALUE_MM)/SUM(t41.KPI_VALUE_MOM)/extract(day from last_day(to_date('${last_month_end}','yyyymmdd')))*(add_months(trunc(to_date('${last_month_end}','yyyymmdd'),'yyyy'),12)-trunc(to_date('${last_month_end}','yyyymmdd'),'yyyy')) end as kpi_value_m_ck
                 ,case when SUM(t41.KPI_VALUE_YOY)=0 then 0 else SUM(t41.KPI_VALUE_YY)/SUM(t41.KPI_VALUE_YOY)/(to_date('${last_month_end}','yyyymmdd')-decode(substr('${last_month_end}',5,4),'1231',to_date('${last_year_start}','yyyymmdd'),to_date('${year_start}','yyyymmdd'))+1)*(add_months(trunc(to_date('${last_month_end}','yyyymmdd'),'yyyy'),12)-trunc(to_date('${last_month_end}','yyyymmdd'),'yyyy')) end as kpi_value_y_ck
                 ,t41.CURR_CD,substr(t41.MANAGER_ORG,1,3) as MANAGER_ORG
                from itl_edw_cass_R_RPT_RST0015 t41 --报表-管驾明细表 
               where t41.etl_dt=to_date('${last_month_end}','yyyymmdd')
                and t41.index_level1_class = '存贷利差'            
                and substr(t41.COM_LINE_NAME,length(t41.COM_LINE_NAME)-1)='存款'
                and trim(t41.index_level2_class) is null
                group by t41.CURR_CD,substr(t41.MANAGER_ORG,1,3)) t4
  on  t4.CURR_CD = t2.CURR_CD
  and t4.MANAGER_ORG=substr(t2.MANAGER_ORG,1,3)
LEFT JOIN mtl_cmm_intnal_org_info t5 --None 
 on t5.etl_dt=to_date('${last_month_end}','yyyymmdd')
and t5.ORG_ID=substr(t2.MANAGER_ORG,1,3)
where t1.source_system='数仓-管会'
and substr(t1.index_no_mcs,length(t1.index_no_mcs)-3,4)='0000' --一级指标
GROUP BY t2.CURR_CD
,t2.CURR_NAME
,t1.index_no_mcs
,t1.index_name_mcs
,substr(t2.MANAGER_ORG,1,3)
,t5.ORG_NAME
,t1.UNIT;
commit;

/*==============第7组==============*/

--汇总指标事实表:三级指标-全行
insert into ${idl_schema}.tmp_mc_index_fact_cas_01(
    etl_dt                                                       --数据日期
    ,curr_cd                                                     --币种
    ,curr_name                                                   --币种名称
    ,index_no                                                    --指标编号
    ,index_name                                                  --指标名称
    -- 5
    ,manager_org                                                 --考核机构
    ,manager_org_name                                            --考核机构名称
    ,kpi_value_y                                                 --当年值
    ,kpi_value_m                                                 --当月值
    ,ind_unit                                                    --指标单位
    -- 10
)
select
    to_date('${last_month_end}','yyyymmdd') as etl_dt                --None
    ,t2.CURR_CD as curr_cd                                       --币种
    ,t2.CURR_NAME as curr_name                                   --币种名称
    ,t1.index_no_mcs as index_no                                 --管驾指标编号
    ,t1.index_name_mcs as index_name                             --管驾指标名称
    -- 5
    ,'000000' as manager_org                                     --考核机构
    ,'全行' as manager_org_name                                    --考核机构名称
    ,case when t1.UNIT ='%' and sum(t2.KPI_VALUE_YOY)>0 then SUM(T2.KPI_VALUE_YY)/SUM(t2.KPI_VALUE_YOY)/(to_date('${last_month_end}','yyyymmdd')-decode(substr('${last_month_end}',5,4),'1231',to_date('${last_year_start}','yyyymmdd'),to_date('${year_start}','yyyymmdd'))+1)*(add_months(trunc(to_date('${last_month_end}','yyyymmdd'),'yyyy'),12)-trunc(to_date('${last_month_end}','yyyymmdd'),'yyyy'))
     when t1.UNIT ='%' and sum(t2.KPI_VALUE_YOY)=0 then 0
     else SUM(t2.KPI_VALUE_Y)
end as kpi_value_y --当年值
    ,case when t1.UNIT ='%' and sum(t2.KPI_VALUE_MOM)>0 then SUM(T2.KPI_VALUE_MM)/SUM(t2.KPI_VALUE_MOM)/extract(day from last_day(to_date('${last_month_end}','yyyymmdd')))*(add_months(trunc(to_date('${last_month_end}','yyyymmdd'),'yyyy'),12)-trunc(to_date('${last_month_end}','yyyymmdd'),'yyyy'))
     when t1.UNIT ='%' and sum(t2.KPI_VALUE_MOM)=0 then 0
     else SUM(t2.KPI_VALUE_M)
end as kpi_value_m --当月值
    ,t1.UNIT as ind_unit                                         --None
    -- 10
 from mc_index_define t1 --指标定义表 
INNER JOIN itl_edw_cass_R_RPT_RST0015 t2 --报表-管驾明细表 
 on t2.etl_dt=to_date('${last_month_end}','yyyymmdd')
and t2.index_level3_class = t1.index_name_mcs
--and t2.index_level1_class = t1.index_clsaa_s_mcs
--and t2.index_level2_class = t1.index_clsaa_t_mcs
where t1.source_system='数仓-管会'
and substr(t1.index_no_mcs,length(t1.index_no_mcs)-1,2)<>'00' --三级指标
GROUP BY t2.CURR_CD
,t2.CURR_NAME
,t1.index_no_mcs
,t1.index_name_mcs
,t1.UNIT;
commit;


/*==============第8组==============*/

--汇总指标事实表:二级指标-全行
insert into ${idl_schema}.tmp_mc_index_fact_cas_01(
    etl_dt                                                       --数据日期
    ,curr_cd                                                     --币种
    ,curr_name                                                   --币种名称
    ,index_no                                                    --指标编号
    ,index_name                                                  --指标名称
    -- 5
    ,manager_org                                                 --考核机构
    ,manager_org_name                                            --考核机构名称
    ,kpi_value_y                                                 --当年值
    ,kpi_value_m                                                 --当月值
    ,ind_unit                                                    --指标单位
    -- 10
)
select
    to_date('${last_month_end}','yyyymmdd') as etl_dt                --None
    ,t2.CURR_CD as curr_cd                                       --币种
    ,t2.CURR_NAME as curr_name                                   --币种名称
    ,t1.index_no_mcs as index_no                                 --管驾指标编号
    ,t1.index_name_mcs as index_name                             --管驾指标名称
    -- 5
    ,'000000' as manager_org                                     --考核机构
    ,'全行' as manager_org_name                                    --考核机构名称
    ,case when t1.UNIT ='%'  then nvl(max(t3.kpi_value_y_dk),0)-nvl(max(t4.kpi_value_y_ck),0)
     else SUM(t2.KPI_VALUE_Y)
     end as kpi_value_y --当年值
    ,case when t1.UNIT ='%'  then nvl(max(t3.kpi_value_m_dk),0)-nvl(max(t4.kpi_value_m_ck),0)
     else SUM(t2.KPI_VALUE_M)
     end as kpi_value_m --当月值
    ,t1.UNIT as ind_unit                                         --None
    -- 10
 from mc_index_define t1 --指标定义表 
INNER JOIN itl_edw_cass_R_RPT_RST0015 t2 --报表-管驾明细表 
 on t2.etl_dt=to_date('${last_month_end}','yyyymmdd')
and t2.index_level1_class = t1.index_clsaa_s_mcs
and t2.index_level2_class = t1.index_clsaa_t_mcs
left JOIN (select case when SUM(t31.KPI_VALUE_MOM)=0 then 0 else SUM(t31.KPI_VALUE_MM)/SUM(t31.KPI_VALUE_MOM)/extract(day from last_day(to_date('${last_month_end}','yyyymmdd')))*(add_months(trunc(to_date('${last_month_end}','yyyymmdd'),'yyyy'),12)-trunc(to_date('${last_month_end}','yyyymmdd'),'yyyy')) end as kpi_value_m_dk
                 ,case when SUM(t31.KPI_VALUE_YOY)=0 then 0 else SUM(t31.KPI_VALUE_YY)/SUM(t31.KPI_VALUE_YOY)/(to_date('${last_month_end}','yyyymmdd')-decode(substr('${last_month_end}',5,4),'1231',to_date('${last_year_start}','yyyymmdd'),to_date('${year_start}','yyyymmdd'))+1)*(add_months(trunc(to_date('${last_month_end}','yyyymmdd'),'yyyy'),12)-trunc(to_date('${last_month_end}','yyyymmdd'),'yyyy')) end as kpi_value_y_dk
                 ,t31.CURR_CD,t31.index_level2_class
                from itl_edw_cass_R_RPT_RST0015 t31 --报表-管驾明细表 
               where t31.etl_dt=to_date('${last_month_end}','yyyymmdd')
                and t31.index_level1_class = '存贷利差'            
                and substr(t31.COM_LINE_NAME,length(t31.COM_LINE_NAME)-1)='贷款'
                group by t31.CURR_CD,t31.index_level2_class) t3
  on  t3.CURR_CD = t2.CURR_CD
  and t3.index_level2_class = t1.index_clsaa_t_mcs
left JOIN (select case when SUM(t41.KPI_VALUE_MOM)=0 then 0 else SUM(t41.KPI_VALUE_MM)/SUM(t41.KPI_VALUE_MOM)/extract(day from last_day(to_date('${last_month_end}','yyyymmdd')))*(add_months(trunc(to_date('${last_month_end}','yyyymmdd'),'yyyy'),12)-trunc(to_date('${last_month_end}','yyyymmdd'),'yyyy')) end as kpi_value_m_ck
                 ,case when SUM(t41.KPI_VALUE_YOY)=0 then 0 else SUM(t41.KPI_VALUE_YY)/SUM(t41.KPI_VALUE_YOY)/(to_date('${last_month_end}','yyyymmdd')-decode(substr('${last_month_end}',5,4),'1231',to_date('${last_year_start}','yyyymmdd'),to_date('${year_start}','yyyymmdd'))+1)*(add_months(trunc(to_date('${last_month_end}','yyyymmdd'),'yyyy'),12)-trunc(to_date('${last_month_end}','yyyymmdd'),'yyyy')) end as kpi_value_y_ck
                 ,t41.CURR_CD,t41.index_level2_class
                from itl_edw_cass_R_RPT_RST0015 t41 --报表-管驾明细表 
               where t41.etl_dt=to_date('${last_month_end}','yyyymmdd')
                and t41.index_level1_class = '存贷利差'            
                and substr(t41.COM_LINE_NAME,length(t41.COM_LINE_NAME)-1)='存款'
                group by t41.CURR_CD,t41.index_level2_class) t4
  on  t4.CURR_CD = t2.CURR_CD
  and t4.index_level2_class = t1.index_clsaa_t_mcs
where t1.source_system='数仓-管会'
and substr(t1.index_no_mcs,length(t1.index_no_mcs)-1,2)='00'
and substr(t1.index_no_mcs,length(t1.index_no_mcs)-4,2)<>'00' --二级指标
GROUP BY t2.CURR_CD
,t2.CURR_NAME
,t1.index_no_mcs
,t1.index_name_mcs
,t1.UNIT;
commit;

/*==============第9组==============*/

--汇总指标事实表:一级指标-全行
insert into ${idl_schema}.tmp_mc_index_fact_cas_01(
    etl_dt                                                       --数据日期
    ,curr_cd                                                     --币种
    ,curr_name                                                   --币种名称
    ,index_no                                                    --指标编号
    ,index_name                                                  --指标名称
    -- 5
    ,manager_org                                                 --考核机构
    ,manager_org_name                                            --考核机构名称
    ,kpi_value_y                                                 --当年值
    ,kpi_value_m                                                 --当月值
    ,ind_unit                                                    --指标单位
    -- 10
)
select
    to_date('${last_month_end}','yyyymmdd') as etl_dt                --None
    ,t2.CURR_CD as curr_cd                                       --币种
    ,t2.CURR_NAME as curr_name                                   --币种名称
    ,t1.index_no_mcs as index_no                                 --管驾指标编号
    ,t1.index_name_mcs as index_name                             --管驾指标名称
    -- 5
    ,'000000' as manager_org                                     --考核机构
    ,'全行' as manager_org_name                                    --考核机构名称
    ,case when t1.UNIT ='%'  then nvl(max(t3.kpi_value_y_dk),0)-nvl(max(t4.kpi_value_y_ck),0)
     else SUM(t2.KPI_VALUE_Y)
     end as kpi_value_y --当年值
    ,case when t1.UNIT ='%'  then nvl(max(t3.kpi_value_m_dk),0)-nvl(max(t4.kpi_value_m_ck),0)
     else SUM(t2.KPI_VALUE_M)
     end as kpi_value_m --当月值
    ,t1.UNIT as ind_unit                                         --None
    -- 10
 from mc_index_define t1 --指标定义表 
INNER JOIN itl_edw_cass_R_RPT_RST0015 t2 --报表-管驾明细表 
 on t2.etl_dt=to_date('${last_month_end}','yyyymmdd')
and t2.index_level1_class = t1.index_clsaa_s_mcs
left JOIN (select case when SUM(t31.KPI_VALUE_MOM)=0 then 0 else SUM(t31.KPI_VALUE_MM)/SUM(t31.KPI_VALUE_MOM)/extract(day from last_day(to_date('${last_month_end}','yyyymmdd')))*(add_months(trunc(to_date('${last_month_end}','yyyymmdd'),'yyyy'),12)-trunc(to_date('${last_month_end}','yyyymmdd'),'yyyy')) end as kpi_value_m_dk
                 ,case when SUM(t31.KPI_VALUE_YOY)=0 then 0 else SUM(t31.KPI_VALUE_YY)/SUM(t31.KPI_VALUE_YOY)/(to_date('${last_month_end}','yyyymmdd')-decode(substr('${last_month_end}',5,4),'1231',to_date('${last_year_start}','yyyymmdd'),to_date('${year_start}','yyyymmdd'))+1)*(add_months(trunc(to_date('${last_month_end}','yyyymmdd'),'yyyy'),12)-trunc(to_date('${last_month_end}','yyyymmdd'),'yyyy')) end as kpi_value_y_dk
                 ,t31.CURR_CD
                from itl_edw_cass_R_RPT_RST0015 t31 --报表-管驾明细表 
               where t31.etl_dt=to_date('${last_month_end}','yyyymmdd')
                and t31.index_level1_class = '存贷利差'            
                and substr(t31.COM_LINE_NAME,length(t31.COM_LINE_NAME)-1)='贷款'
                and trim(t31.index_level2_class) is null
                group by t31.CURR_CD) t3
  on  t3.CURR_CD = t2.CURR_CD
left JOIN (select case when SUM(t41.KPI_VALUE_MOM)=0 then 0 else SUM(t41.KPI_VALUE_MM)/SUM(t41.KPI_VALUE_MOM)/extract(day from last_day(to_date('${last_month_end}','yyyymmdd')))*(add_months(trunc(to_date('${last_month_end}','yyyymmdd'),'yyyy'),12)-trunc(to_date('${last_month_end}','yyyymmdd'),'yyyy')) end as kpi_value_m_ck
                 ,case when SUM(t41.KPI_VALUE_YOY)=0 then 0 else SUM(t41.KPI_VALUE_YY)/SUM(t41.KPI_VALUE_YOY)/(to_date('${last_month_end}','yyyymmdd')-decode(substr('${last_month_end}',5,4),'1231',to_date('${last_year_start}','yyyymmdd'),to_date('${year_start}','yyyymmdd'))+1)*(add_months(trunc(to_date('${last_month_end}','yyyymmdd'),'yyyy'),12)-trunc(to_date('${last_month_end}','yyyymmdd'),'yyyy')) end as kpi_value_y_ck
                 ,t41.CURR_CD
                from itl_edw_cass_R_RPT_RST0015 t41 --报表-管驾明细表 
               where t41.etl_dt=to_date('${last_month_end}','yyyymmdd')
                and t41.index_level1_class = '存贷利差'            
                and substr(t41.COM_LINE_NAME,length(t41.COM_LINE_NAME)-1)='存款'
                and trim(t41.index_level2_class) is null
                group by t41.CURR_CD) t4
  on  t4.CURR_CD = t2.CURR_CD
where t1.source_system='数仓-管会'
and substr(t1.index_no_mcs,length(t1.index_no_mcs)-3,4)='0000' --一级指标
GROUP BY t2.CURR_CD
,t2.CURR_NAME
,t1.index_no_mcs
,t1.index_name_mcs
,t1.UNIT;
commit;

/*==============第10组==============*/

--插入目标表:当月值
insert into ${idl_schema}.mc_index_fact(
    etl_dt                                                       --ETL处理日期
    ,index_no                                                    --指标编码
    ,index_name                                                  --指标名称
    ,org_no                                                      --机构编码
    ,org_name                                                    --机构名称
    -- 5
    ,super_org_no                                                --上级机构编码
    ,org_sort                                                    --机构分类
    ,curr_no                                                     --币种编号
    ,curr_name                                                   --币种名称
    ,index_value                                                 --指标值
    -- 10
    ,accu_index_value_m                                          --当月累计
    ,accu_index_value_y                                          --当年累计
    ,rate_up_day                                                 --比上日
    ,rate_last_month                                             --比上月
    ,rate_last_year                                              --比上年
    -- 15
    ,rate_last_period                                            --同比
    ,rate_up_day_per                                             --比上日百分比
    ,rate_last_month_per                                         --比上月百分比
    ,rate_last_year_per                                          --比上年百分比
    ,rate_last_period_per                                        --同比百分比
    -- 20
    ,index_ranking                                               --当前排名
    ,index_ranking_cha                                           --排名变动
    ,index_value_avg                                             --均值
    ,index_value_limit                                           --阀值
    ,ratio_index                                                 --结构占比
    -- 25
    ,ratio_org                                                   --分行贡献度
    ,unit                                                        --单位
    ,frequency                                                   --频度
    ,measure_no                                                  --度量编号
    ,source_sys                                                  --字段中文1
    -- 30
    ,index_measure                                               --度量名称
    ,etl_timestamp                                               --ETL处理时间戳
    ,rate_last_quater                                            --比上季
    ,rate_last_quater_per                                        --比上季百分比
    ,supervision_require                                         --监管要求
    -- 35
    ,limit_value                                                 --限额值
    ,prewarning_value                                            --预警值
    ,intrv_type                                                  --区间类型
    ,rate_last_week                                              --比上周
)
select
    to_date('${last_month_end}','yyyymmdd') as etl_dt                --None
    ,t1.index_no as index_no                                     --None
    ,t1.index_name as index_name                                 --None
    ,t1.MANAGER_ORG as org_no                                    --None
    ,t2.org_name as org_name                                     --None
    -- 5
    ,t2.BRCH_ID as super_org_no                                  --None
    ,'' as org_sort                                              --None
    ,t1.CURR_CD as curr_no                                       --None
    ,t1.CURR_NAME as curr_name                                   --None
    ,t1.KPI_VALUE_M as index_value                               --None
    -- 10
    ,t1.KPI_VALUE_M as accu_index_value_m                        --None
    ,0 as accu_index_value_y                                     --None
    ,0 as rate_up_day                                            --None
    ,coalesce(t1.KPI_VALUE_M,0) - coalesce(t3.INDEX_VALUE,0) as rate_last_month --None
    ,coalesce(t1.KPI_VALUE_M,0) - coalesce(t4.INDEX_VALUE,0) as rate_last_year                                         --None
    -- 15
    ,coalesce(t1.KPI_VALUE_M,0) - coalesce(t5.INDEX_VALUE,0) as rate_last_period                                       --None
    ,0 as rate_up_day_per                                        --None
    ,case when coalesce(t3.INDEX_VALUE ,0) =0 then 0 
               else  round((coalesce(t1.KPI_VALUE_M,0) - coalesce(t3.INDEX_VALUE,0)) / coalesce(t3.INDEX_VALUE,0),6) 
               end as rate_last_month_per --None
    ,case when coalesce(t4.INDEX_VALUE ,0) =0 then 0 
               else  round((coalesce(t1.KPI_VALUE_M,0) - coalesce(t4.INDEX_VALUE,0)) / coalesce(t4.INDEX_VALUE,0),6) 
               end as rate_last_year_per                                     --None
    ,case when coalesce(t5.INDEX_VALUE ,0) =0 then 0 
               else  round((coalesce(t1.KPI_VALUE_M,0) - coalesce(t5.INDEX_VALUE,0)) / coalesce(t5.INDEX_VALUE,0),6) 
               end as rate_last_period_per                                   --None
    -- 20
    ,0 as index_ranking                                          --None
    ,0 as index_ranking_cha                                      --None
    ,0 as index_value_avg                                        --None
    ,0 as index_value_limit                                      --None
    ,0 as ratio_index                                            --None
    -- 25
    ,0 as ratio_org                                              --None
    ,t1.ind_unit as unit                                         --None
    ,'' as frequency                                             --None
    ,'002' as measure_no                                         --None
    ,'CAS' as source_sys                                         --None
    -- 30
    ,'当月值' as index_measure                                      --None
    ,TO_TIMESTAMP('${batch_timestamp}','yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp --None
    ,0 as rate_last_quater                                       --None
    ,0 as rate_last_quater_per                                   --None
    ,'' as supervision_require                                   --None
    -- 35
    ,'' as limit_value                                           --None
    ,'' as prewarning_value                                      --None
    ,'' as intrv_type                                            --None
    ,0 as rate_last_week                                         --None
 from tmp_mc_index_fact_cas_01 t1 --None 
LEFT JOIN mtl_cmm_intnal_org_info t2 --None 
 on t2.etl_dt=to_date('${last_month_end}','yyyymmdd')
and t2.ORG_ID=t1.MANAGER_ORG
LEFT JOIN mc_index_fact t3 --None 
 on t3.etl_dt=to_date('${previous_month_end}','yyyymmdd')
and t3.index_no=t1.index_no
and t3.org_no=t1.MANAGER_ORG
and t3.curr_no=t1.CURR_CD
and t3.MEASURE_NO='002'
LEFT JOIN mc_index_fact t4 --None 
 on t4.etl_dt=decode(substr('${last_month_end}',5,4),'1231',trunc(to_date('${last_month_end}','yyyymmdd'),'yy') -1 ,to_date('${last_year_end}','yyyymmdd'))
and t4.index_no=t1.index_no
and t4.org_no=t1.MANAGER_ORG
and t4.curr_no=t1.CURR_CD
and t4.MEASURE_NO='002'
LEFT JOIN mc_index_fact t5 --None 
 on t5.etl_dt=add_months(to_date('${last_month_end}','yyyymmdd'), -12)
and t5.index_no=t1.index_no
and t5.org_no=t1.MANAGER_ORG
and t5.curr_no=t1.CURR_CD
and t5.MEASURE_NO='002'
;
commit;


/*==============第11组==============*/

--插入目标表:当年值
insert into ${idl_schema}.mc_index_fact(
    etl_dt                                                       --ETL处理日期
    ,index_no                                                    --指标编码
    ,index_name                                                  --指标名称
    ,org_no                                                      --机构编码
    ,org_name                                                    --机构名称
    -- 5
    ,super_org_no                                                --上级机构编码
    ,org_sort                                                    --机构分类
    ,curr_no                                                     --币种编号
    ,curr_name                                                   --币种名称
    ,index_value                                                 --指标值
    -- 10
    ,accu_index_value_m                                          --当月累计
    ,accu_index_value_y                                          --当年累计
    ,rate_up_day                                                 --比上日
    ,rate_last_month                                             --比上月
    ,rate_last_year                                              --比上年
    -- 15
    ,rate_last_period                                            --同比
    ,rate_up_day_per                                             --比上日百分比
    ,rate_last_month_per                                         --比上月百分比
    ,rate_last_year_per                                          --比上年百分比
    ,rate_last_period_per                                        --同比百分比
    -- 20
    ,index_ranking                                               --当前排名
    ,index_ranking_cha                                           --排名变动
    ,index_value_avg                                             --均值
    ,index_value_limit                                           --阀值
    ,ratio_index                                                 --结构占比
    -- 25
    ,ratio_org                                                   --分行贡献度
    ,unit                                                        --单位
    ,frequency                                                   --频度
    ,measure_no                                                  --度量编号
    ,source_sys                                                  --字段中文1
    -- 30
    ,index_measure                                               --度量名称
    ,etl_timestamp                                               --ETL处理时间戳
    ,rate_last_quater                                            --比上季
    ,rate_last_quater_per                                        --比上季百分比
    ,supervision_require                                         --监管要求
    -- 35
    ,limit_value                                                 --限额值
    ,prewarning_value                                            --预警值
    ,intrv_type                                                  --区间类型
    ,rate_last_week                                              --比上周
)
select
    to_date('${last_month_end}','yyyymmdd') as etl_dt                --None
    ,t1.index_no as index_no                                     --None
    ,t1.index_name as index_name                                 --None
    ,t1.MANAGER_ORG as org_no                                    --None
    ,t2.org_name as org_name                                     --None
    -- 5
    ,t2.BRCH_ID as super_org_no                                  --None
    ,'' as org_sort                                              --None
    ,t1.CURR_CD as curr_no                                       --None
    ,t1.CURR_NAME as curr_name                                   --None
    ,t1.KPI_VALUE_Y as index_value                               --None
    -- 10
    ,0 as accu_index_value_m                                     --None
    ,t1.KPI_VALUE_Y as accu_index_value_y                        --None
    ,0 as rate_up_day                                            --None
    ,coalesce(t1.KPI_VALUE_Y,0) - coalesce(t4.INDEX_VALUE,0) as rate_last_month --None
    ,coalesce(t1.KPI_VALUE_Y,0) - coalesce(t3.INDEX_VALUE,0) as rate_last_year --None
    -- 15
    ,coalesce(t1.KPI_VALUE_Y,0) - coalesce(t5.INDEX_VALUE,0) as rate_last_period --None
    ,0 as rate_up_day_per                                        --None
    ,case when coalesce(t4.INDEX_VALUE ,0) =0 then 0 
               else  round((coalesce(t1.KPI_VALUE_Y,0) - coalesce(t4.INDEX_VALUE,0)) / coalesce(t4.INDEX_VALUE,0),6) 
               end as rate_last_month_per --None
    ,case when coalesce(t3.INDEX_VALUE ,0) =0 then 0 
               else  round((coalesce(t1.KPI_VALUE_Y,0) - coalesce(t3.INDEX_VALUE,0)) / coalesce(t3.INDEX_VALUE,0),6) 
               end as rate_last_year_per --None
    ,case when coalesce(t5.INDEX_VALUE ,0) =0 then 0 
               else  round((coalesce(t1.KPI_VALUE_Y,0) - coalesce(t5.INDEX_VALUE,0)) / coalesce(t5.INDEX_VALUE,0),6) 
               end as rate_last_period_per --None
    -- 20
    ,0 as index_ranking                                          --None
    ,0 as index_ranking_cha                                      --None
    ,0 as index_value_avg                                        --None
    ,0 as index_value_limit                                      --None
    ,0 as ratio_index                                            --None
    -- 25
    ,0 as ratio_org                                              --None
    ,t1.ind_unit as unit                                         --None
    ,'' as frequency                                             --None
    ,'004' as measure_no                                         --None
    ,'CAS' as source_sys                                         --None
    -- 30
    ,'当年值' as index_measure                                      --None
    ,TO_TIMESTAMP('${batch_timestamp}','yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp --None
    ,0 as rate_last_quater                                       --None
    ,0 as rate_last_quater_per                                   --None
    ,'' as supervision_require                                   --None
    -- 35
    ,'' as limit_value                                           --None
    ,'' as prewarning_value                                      --None
    ,'' as intrv_type                                            --None
    ,0 as rate_last_week                                         --None
 from tmp_mc_index_fact_cas_01 t1 --None 
LEFT JOIN mtl_cmm_intnal_org_info t2 --None 
 on t2.etl_dt=to_date('${last_month_end}','yyyymmdd')
and t2.ORG_ID=t1.MANAGER_ORG
LEFT JOIN mc_index_fact t3 --None 
 on t3.etl_dt=decode(substr('${last_month_end}',5,4),'1231',trunc(to_date('${last_month_end}','yyyymmdd'),'yy') -1 ,to_date('${last_year_end}','yyyymmdd'))
and t3.index_no=t1.index_no
and t3.org_no=t1.MANAGER_ORG
and t3.curr_no=t1.CURR_CD
and t3.MEASURE_NO='004'
LEFT JOIN mc_index_fact t4 --None 
 on t4.etl_dt=to_date('${previous_month_end}','yyyymmdd')
and t4.index_no=t1.index_no
and t4.org_no=t1.MANAGER_ORG
and t4.curr_no=t1.CURR_CD
and t4.MEASURE_NO='004'
LEFT JOIN mc_index_fact t5 --None 
 on t5.etl_dt=add_months(to_date('${last_month_end}','yyyymmdd'), -12)
and t5.index_no=t1.index_no
and t5.org_no=t1.MANAGER_ORG
and t5.curr_no=t1.CURR_CD
and t5.MEASURE_NO='004';
commit;

--delete tmp table
whenever sqlerror continue none;
drop table ${idl_schema}.tmp_mc_index_fact_cas_01 purge;

-- 3.1 gather table status
exec dbms_stats.gather_table_stats(ownname => '${idl_schema}', tabname => 'mc_index_fact',partname => 'p_${last_month_end}_cas', granularity => 'SUBPARTITION', degree => 8, cascade => true);
