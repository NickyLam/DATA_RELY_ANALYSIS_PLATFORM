/*
Purpose:    None-管理会计指标排行明细
Creater:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd idl_mc_adac_ind_ranking_dtl
CreateDate: None
FileType:   DML
Logs:
    表英文名： mc_adac_ind_ranking_dtl
    表中文名： 管理会计指标排行明细
    创建日期： None
    主键字段： None
    归属层次： None
    归属主题： None
    分区粒度： 
    分析人员： None
    时间粒度： None
    保留周期： None
    描述信息： None
    更新记录:
        2024-12-12    郑沛隆    新建脚本    
                    
*/


--设置参数
set timing on
-- 0.1 alter parallel
alter session force parallel query parallel 8;
alter session force parallel dml parallel 8;
-- 1.1 create table for exchage
whenever sqlerror continue none;
alter table ${idl_schema}.mc_adac_ind_ranking_dtl add partition p_${last_month_end} values (to_date('${last_month_end}','yyyymmdd'));
alter table ${idl_schema}.mc_adac_ind_ranking_dtl truncate partition p_${last_month_end};

whenever sqlerror exit sql.sqlcode; 

/*==============第1组==============*/

--临时表01:三级指标-分行
whenever sqlerror continue none;
drop table ${idl_schema}.tmp_mc_adac_ind_ranking_dtl_01 purge;
whenever sqlerror exit sql.sqlcode;
create table ${idl_schema}.tmp_mc_adac_ind_ranking_dtl_01 (
    etl_dt date                                                   --ETL处理日期
    ,curr_no varchar2(10) --币种编号
    ,curr_name varchar2(200) --币种名称
    ,index_no varchar2(60) --指标编号
    ,index_name varchar2(200) --指标名称
    -- 5
    ,org_no varchar2(50) --机构编号
    ,org_name varchar2(200) --机构名称
    ,super_org_no varchar2(60) --上级机构编号
    ,dimen_obj_id varchar2(50) --维度对象编号
    ,dimen_obj_name varchar2(200) --维度对象名称
    -- 10
    ,index_value_m number(38,8) --当月指标值
    ,index_value_y number(38,8) --当年指标值
    ,ranking_dimen_id varchar2(60) --排行维度编号(001分行002支行团队003客户经理004产品)
    ,ranking_dimen_name varchar2(200) --排行维度名称
    ,unit varchar2(60) --单位
    -- 15
)
 ;

insert into ${idl_schema}.tmp_mc_adac_ind_ranking_dtl_01(
    etl_dt                                                       --ETL处理日期
    ,curr_no                                                     --币种编号
    ,curr_name                                                   --币种名称
    ,index_no                                                    --指标编号
    ,index_name                                                  --指标名称
    -- 5
    ,org_no                                                      --机构编号
    ,org_name                                                    --机构名称
    ,super_org_no                                                --上级机构编号
    ,dimen_obj_id                                                --维度对象编号
    ,dimen_obj_name                                              --维度对象名称
     -- 10
    ,index_value_m                                               --当月指标值
    ,index_value_y                                               --当年指标值
    ,ranking_dimen_id                                            --排行维度编号(001分行002支行团队003客户经理004产品)
    ,ranking_dimen_name                                          --排行维度名称
    ,unit                                                        --单位
    -- 15
)
select
    to_date('${last_month_end}','yyyymmdd') as etl_dt                --None
    ,t2.CURR_CD as curr_no                                       --None
    ,t2.CURR_NAME as curr_name                                   --None
    ,t1.index_no_mcs as index_no                                 --None
    ,t1.index_name_mcs as index_name                             --None
    -- 5
    ,substr(t2.MANAGER_ORG,1,3) as org_no                        --None
    ,t3.ORG_NAME as org_name                                     --None
    ,'000000' as super_org_no                                    --None
    ,substr(t2.MANAGER_ORG,1,3) as dimen_obj_id                  --None
    ,t3.ORG_ABBR as dimen_obj_name                               --None
    -- 10
    ,case when t1.UNIT ='%' and sum(t2.KPI_VALUE_MOM)>0 then SUM(T2.KPI_VALUE_MM)/SUM(t2.KPI_VALUE_MOM)/extract(day from last_day(to_date('${last_month_end}','yyyymmdd')))*(add_months(trunc(to_date('${last_month_end}','yyyymmdd'),'yyyy'),12)-trunc(to_date('${last_month_end}','yyyymmdd'),'yyyy'))
     when t1.UNIT ='%' and sum(t2.KPI_VALUE_MOM)=0 then 0
     else SUM(t2.KPI_VALUE_M)
end as index_value_m --None
    ,case when t1.UNIT ='%' and sum(t2.KPI_VALUE_YOY)>0 then SUM(T2.KPI_VALUE_YY)/SUM(t2.KPI_VALUE_YOY)/(to_date('${last_month_end}','yyyymmdd')-decode(substr('${last_month_end}',5,4),'1231',to_date('${last_year_start}','yyyymmdd'),to_date('${year_start}','yyyymmdd'))+1)*(add_months(trunc(to_date('${last_month_end}','yyyymmdd'),'yyyy'),12)-trunc(to_date('${last_month_end}','yyyymmdd'),'yyyy'))

     when t1.UNIT ='%' and sum(t2.KPI_VALUE_YOY)=0 then 0
     else SUM(t2.KPI_VALUE_Y)
end as index_value_y --None
    ,'001' as ranking_dimen_id                                   --None
    ,'分行' as ranking_dimen_name                                  --None
    ,t1.unit as unit                                             --None
    -- 15
 from mc_index_define t1 --指标定义表 
INNER JOIN itl_edw_cass_R_RPT_RST0015 t2 --报表-管驾明细表 
 on t2.etl_dt=to_date('${last_month_end}','yyyymmdd')
and t2.index_level3_class = t1.index_name_mcs
--and t2.index_level1_class = t1.index_clsaa_s_mcs
--and t2.index_level2_class = t1.index_clsaa_t_mcs
INNER JOIN mtl_cmm_intnal_org_info t3 --None 
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
,T3.ORG_ABBR
,t1.unit;
commit;


/*==============第2组==============*/

--临时表01:三级指标-当月-支行
insert into ${idl_schema}.tmp_mc_adac_ind_ranking_dtl_01(
    etl_dt                                                       --ETL处理日期
    ,curr_no                                                     --币种编号
    ,curr_name                                                   --币种名称
    ,index_no                                                    --指标编号
    ,index_name                                                  --指标名称
    -- 5
    ,org_no                                                      --机构编号
    ,org_name                                                    --机构名称
    ,super_org_no                                                --上级机构编号
    ,dimen_obj_id                                                --维度对象编号
    ,dimen_obj_name                                              --维度对象名称
    -- 10    
    ,index_value_m                                               --当月指标值
    ,index_value_y                                               --当年指标值
    ,ranking_dimen_id                                            --排行维度编号(001分行002支行团队003客户经理004产品)
    ,ranking_dimen_name                                          --排行维度名称
    ,unit                                                        --单位
    -- 15
)
select
    to_date('${last_month_end}','yyyymmdd') as etl_dt                --None
    ,t2.CURR_CD as curr_no                                       --None
    ,t2.CURR_NAME as curr_name                                   --None
    ,t1.index_no_mcs as index_no                                 --None
    ,t1.index_name_mcs as index_name                             --None
    -- 5
    ,t2.MANAGER_ORG as org_no                                    --None
    ,t2.MANAGER_ORG_NAME as org_name                             --None
    ,substr(t2.MANAGER_ORG,1,3) as super_org_no                  --None
    ,t2.MANAGER_ORG as dimen_obj_id                              --None
    ,t3.ORG_NAME as dimen_obj_name                               --None
    -- 10
    ,case when t1.UNIT ='%' and sum(t2.KPI_VALUE_MOM)>0 then SUM(T2.KPI_VALUE_MM)/SUM(t2.KPI_VALUE_MOM)/extract(day from last_day(to_date('${last_month_end}','yyyymmdd')))*(add_months(trunc(to_date('${last_month_end}','yyyymmdd'),'yyyy'),12)-trunc(to_date('${last_month_end}','yyyymmdd'),'yyyy'))
     when t1.UNIT ='%' and sum(t2.KPI_VALUE_MOM)=0 then 0
     else SUM(t2.KPI_VALUE_M)
end as index_value_m --None
    ,case when t1.UNIT ='%' and sum(t2.KPI_VALUE_YOY)>0 then SUM(T2.KPI_VALUE_YY)/SUM(t2.KPI_VALUE_YOY)/(to_date('${last_month_end}','yyyymmdd')-decode(substr('${last_month_end}',5,4),'1231',to_date('${last_year_start}','yyyymmdd'),to_date('${year_start}','yyyymmdd'))+1)*(add_months(trunc(to_date('${last_month_end}','yyyymmdd'),'yyyy'),12)-trunc(to_date('${last_month_end}','yyyymmdd'),'yyyy'))

     when t1.UNIT ='%' and sum(t2.KPI_VALUE_YOY)=0 then 0
     else SUM(t2.KPI_VALUE_Y)
end as index_value_y --None
    ,'002' as ranking_dimen_id                                   --None
    ,'支行团队' as ranking_dimen_name                                --None
    ,t1.unit as unit                                             --None
    -- 15
 from mc_index_define t1 --指标定义表 
INNER JOIN itl_edw_cass_R_RPT_RST0015 t2 --报表-管驾明细表 
 on t2.etl_dt=to_date('${last_month_end}','yyyymmdd')
and t2.index_level3_class = t1.index_name_mcs
--and t2.index_level1_class = t1.index_clsaa_s_mcs
--and t2.index_level2_class = t1.index_clsaa_t_mcs
and length(t2.MANAGER_ORG)>3
and t2.MANAGER_ORG<>'000000'
INNER JOIN mtl_cmm_intnal_org_info t3 --None 
 on t3.etl_dt=to_date('${last_month_end}','yyyymmdd')
and t3.ORG_ID=t2.MANAGER_ORG

where t1.source_system='数仓-管会'
and substr(t1.index_no_mcs,length(t1.index_no_mcs)-1,2)<>'00' --三级指标
GROUP BY t2.CURR_CD
,t2.CURR_NAME
,t1.index_no_mcs
,t1.index_name_mcs
,t2.MANAGER_ORG
,t2.MANAGER_ORG_NAME
,substr(t2.MANAGER_ORG,1,3)
,t2.MANAGER_ORG
,t3.ORG_NAME
,t1.unit;
commit;


/*==============第3组==============*/

--临时表01:三级指标-当月-客户经理
insert into ${idl_schema}.tmp_mc_adac_ind_ranking_dtl_01(
    etl_dt                                                       --ETL处理日期
    ,curr_no                                                     --币种编号
    ,curr_name                                                   --币种名称
    ,index_no                                                    --指标编号
    ,index_name                                                  --指标名称
    -- 5
    ,org_no                                                      --机构编号
    ,org_name                                                    --机构名称
    ,super_org_no                                                --上级机构编号
    ,dimen_obj_id                                                --维度对象编号
    ,dimen_obj_name                                              --维度对象名称
    -- 10
    ,index_value_m                                               --当月指标值
    ,index_value_y                                               --当年指标值
    ,ranking_dimen_id                                            --排行维度编号(001分行002支行团队003客户经理004产品)
    ,ranking_dimen_name                                          --排行维度名称
    ,unit                                                        --单位
    -- 15
)
select
    to_date('${last_month_end}','yyyymmdd') as etl_dt                --None
    ,t2.CURR_CD as curr_no                                       --None
    ,t2.CURR_NAME as curr_name                                   --None
    ,t1.index_no_mcs as index_no                                 --None
    ,t1.index_name_mcs as index_name                             --None
    -- 5
    ,t2.MANAGER_ORG as org_no                                    --None
    ,t2.MANAGER_ORG_NAME as org_name                             --None
    ,substr(t2.MANAGER_ORG,1,3) as super_org_no                  --None
    ,t2.CUST_MGR_NO as dimen_obj_id                              --None
    ,t2.CUST_MGR_NAME as dimen_obj_name                          --None
    -- 10
    ,case when t1.UNIT ='%' and sum(t2.KPI_VALUE_MOM)>0 then SUM(T2.KPI_VALUE_MM)/SUM(t2.KPI_VALUE_MOM)/extract(day from last_day(to_date('${last_month_end}','yyyymmdd')))*(add_months(trunc(to_date('${last_month_end}','yyyymmdd'),'yyyy'),12)-trunc(to_date('${last_month_end}','yyyymmdd'),'yyyy'))
     when t1.UNIT ='%' and sum(t2.KPI_VALUE_MOM)=0 then 0
     else SUM(t2.KPI_VALUE_M)
end as index_value_m --None
    ,case when t1.UNIT ='%' and sum(t2.KPI_VALUE_YOY)>0 then SUM(T2.KPI_VALUE_YY)/SUM(t2.KPI_VALUE_YOY)/(to_date('${last_month_end}','yyyymmdd')-decode(substr('${last_month_end}',5,4),'1231',to_date('${last_year_start}','yyyymmdd'),to_date('${year_start}','yyyymmdd'))+1)*(add_months(trunc(to_date('${last_month_end}','yyyymmdd'),'yyyy'),12)-trunc(to_date('${last_month_end}','yyyymmdd'),'yyyy'))

     when t1.UNIT ='%' and sum(t2.KPI_VALUE_YOY)=0 then 0
     else SUM(t2.KPI_VALUE_Y)
end as index_value_y --None
    ,'003' as ranking_dimen_id                                   --None
    ,'客户经理' as ranking_dimen_name                                --None
    ,t1.unit as unit                                             --None
    -- 15
 from mc_index_define t1 --指标定义表 
INNER JOIN itl_edw_cass_R_RPT_RST0015 t2 --报表-管驾明细表 
 on t2.etl_dt=to_date('${last_month_end}','yyyymmdd')
and t2.index_level3_class = t1.index_name_mcs
--and t2.index_level1_class = t1.index_clsaa_s_mcs
--and t2.index_level2_class = t1.index_clsaa_t_mcs
and t2.CUST_MGR_NO not like 'XN%'
and trim(t2.CUST_MGR_NO) is not null
and t2.CUST_MGR_NO <>'DEF'
INNER JOIN mtl_cmm_intnal_org_info t3 --None 
 on t3.etl_dt=to_date('${last_month_end}','yyyymmdd')
and t3.ORG_ID=t2.MANAGER_ORG

where t1.source_system='数仓-管会'
and substr(t1.index_no_mcs,length(t1.index_no_mcs)-1,2)<>'00' --三级指标
GROUP BY t2.CURR_CD
,t2.CURR_NAME
,t1.index_no_mcs
,t1.index_name_mcs
,substr(t2.MANAGER_ORG,1,3)
,t2.MANAGER_ORG
,t2.MANAGER_ORG_NAME
,t3.ORG_NAME
,t2.CUST_MGR_NO
,t2.CUST_MGR_NAME
,t1.unit;
commit;


/*==============第4.1组==============*/

--临时表01:三级指标-当月-支行-产品
insert into ${idl_schema}.tmp_mc_adac_ind_ranking_dtl_01(
    etl_dt                                                       --ETL处理日期
    ,curr_no                                                     --币种编号
    ,curr_name                                                   --币种名称
    ,index_no                                                    --指标编号
    ,index_name                                                  --指标名称
    -- 5
    ,org_no                                                      --机构编号
    ,org_name                                                    --机构名称
    ,super_org_no                                                --上级机构编号
    ,dimen_obj_id                                                --维度对象编号
    ,dimen_obj_name                                              --维度对象名称
    -- 10    
    ,index_value_m                                               --当月指标值
    ,index_value_y                                               --当年指标值
    ,ranking_dimen_id                                            --排行维度编号(001分行002支行团队003客户经理004产品)
    ,ranking_dimen_name                                          --排行维度名称
    ,unit                                                        --单位
    -- 15
)
select
    to_date('${last_month_end}','yyyymmdd') as etl_dt                --None
    ,t2.CURR_CD as curr_no                                       --None
    ,t2.CURR_NAME as curr_name                                   --None
    ,t1.index_no_mcs as index_no                                 --None
    ,t1.index_name_mcs as index_name                             --None
    -- 5
    ,t2.MANAGER_ORG as org_no                                    --None
    ,t2.MANAGER_ORG_NAME as org_name                             --None
    ,substr(t2.MANAGER_ORG,1,3) as super_org_no                  --None
    ,t2.STD_PRO_NO as dimen_obj_id                               --None
    ,t2.STD_PRO_NAME as dimen_obj_name                           --None
    -- 10
    ,case when t1.UNIT ='%' and sum(t2.KPI_VALUE_MOM)>0 then SUM(T2.KPI_VALUE_MM)/SUM(t2.KPI_VALUE_MOM)/extract(day from last_day(to_date('${last_month_end}','yyyymmdd')))*(add_months(trunc(to_date('${last_month_end}','yyyymmdd'),'yyyy'),12)-trunc(to_date('${last_month_end}','yyyymmdd'),'yyyy'))
     when t1.UNIT ='%' and sum(t2.KPI_VALUE_MOM)=0 then 0
     else SUM(t2.KPI_VALUE_M)
end as index_value_m --None
    ,case when t1.UNIT ='%' and sum(t2.KPI_VALUE_YOY)>0 then SUM(T2.KPI_VALUE_YY)/SUM(t2.KPI_VALUE_YOY)/(to_date('${last_month_end}','yyyymmdd')-decode(substr('${last_month_end}',5,4),'1231',to_date('${last_year_start}','yyyymmdd'),to_date('${year_start}','yyyymmdd'))+1)*(add_months(trunc(to_date('${last_month_end}','yyyymmdd'),'yyyy'),12)-trunc(to_date('${last_month_end}','yyyymmdd'),'yyyy'))

     when t1.UNIT ='%' and sum(t2.KPI_VALUE_YOY)=0 then 0
     else SUM(t2.KPI_VALUE_Y)
end as index_value_y --None
    ,'004' as ranking_dimen_id                                   --None
    ,'产品' as ranking_dimen_name                                  --None
    ,t1.unit as unit                                             --None
    -- 15
 from mc_index_define t1 --指标定义表 
INNER JOIN itl_edw_cass_R_RPT_RST0015 t2 --报表-管驾明细表 
 on t2.etl_dt=to_date('${last_month_end}','yyyymmdd')
and t2.index_level3_class = t1.index_name_mcs
--and t2.index_level1_class = t1.index_clsaa_s_mcs
--and t2.index_level2_class = t1.index_clsaa_t_mcs
and length(t2.MANAGER_ORG)>3
and t2.MANAGER_ORG<>'000000'
INNER JOIN mtl_cmm_intnal_org_info t3 --None 
 on t3.etl_dt=to_date('${last_month_end}','yyyymmdd')
and t3.ORG_ID=t2.MANAGER_ORG
where t1.source_system='数仓-管会'
and substr(t1.index_no_mcs,length(t1.index_no_mcs)-1,2)<>'00' --三级指标
GROUP BY t2.CURR_CD
,t2.CURR_NAME
,t1.index_no_mcs
,t1.index_name_mcs
,substr(t2.MANAGER_ORG,1,3)
,t2.MANAGER_ORG
,t2.MANAGER_ORG_NAME
,t3.ORG_NAME
,t2.STD_PRO_NO
,t2.STD_PRO_NAME
,t1.unit;
commit;

/*==============第4.2组==============*/

--临时表01:三级指标-当月-分行-产品
insert into ${idl_schema}.tmp_mc_adac_ind_ranking_dtl_01(
    etl_dt                                                       --ETL处理日期
    ,curr_no                                                     --币种编号
    ,curr_name                                                   --币种名称
    ,index_no                                                    --指标编号
    ,index_name                                                  --指标名称
    -- 5
    ,org_no                                                      --机构编号
    ,org_name                                                    --机构名称
    ,super_org_no                                                --上级机构编号
    ,dimen_obj_id                                                --维度对象编号
    ,dimen_obj_name                                              --维度对象名称
    -- 10    
    ,index_value_m                                               --当月指标值
    ,index_value_y                                               --当年指标值
    ,ranking_dimen_id                                            --排行维度编号(001分行002支行团队003客户经理004产品)
    ,ranking_dimen_name                                          --排行维度名称
    ,unit                                                        --单位
    -- 15
)
select
    to_date('${last_month_end}','yyyymmdd') as etl_dt                --None
    ,t2.CURR_CD as curr_no                                       --None
    ,t2.CURR_NAME as curr_name                                   --None
    ,t1.index_no_mcs as index_no                                 --None
    ,t1.index_name_mcs as index_name                             --None
    -- 5
    ,substr(t2.MANAGER_ORG,1,3) as org_no                                    --None
    ,t3.ORG_NAME as org_name                             --None
    ,'000000' as super_org_no                  --None
    ,t2.STD_PRO_NO as dimen_obj_id                               --None
    ,t2.STD_PRO_NAME as dimen_obj_name                           --None
    -- 10
    ,case when t1.UNIT ='%' and sum(t2.KPI_VALUE_MOM)>0 then SUM(T2.KPI_VALUE_MM)/SUM(t2.KPI_VALUE_MOM)/extract(day from last_day(to_date('${last_month_end}','yyyymmdd')))*(add_months(trunc(to_date('${last_month_end}','yyyymmdd'),'yyyy'),12)-trunc(to_date('${last_month_end}','yyyymmdd'),'yyyy'))
     when t1.UNIT ='%' and sum(t2.KPI_VALUE_MOM)=0 then 0
     else SUM(t2.KPI_VALUE_M)
end as index_value_m --None
    ,case when t1.UNIT ='%' and sum(t2.KPI_VALUE_YOY)>0 then SUM(T2.KPI_VALUE_YY)/SUM(t2.KPI_VALUE_YOY)/(to_date('${last_month_end}','yyyymmdd')-decode(substr('${last_month_end}',5,4),'1231',to_date('${last_year_start}','yyyymmdd'),to_date('${year_start}','yyyymmdd'))+1)*(add_months(trunc(to_date('${last_month_end}','yyyymmdd'),'yyyy'),12)-trunc(to_date('${last_month_end}','yyyymmdd'),'yyyy'))

     when t1.UNIT ='%' and sum(t2.KPI_VALUE_YOY)=0 then 0
     else SUM(t2.KPI_VALUE_Y)
end as index_value_y --None
    ,'004' as ranking_dimen_id                                   --None
    ,'产品' as ranking_dimen_name                                  --None
    ,t1.unit as unit                                             --None
    -- 15
 from mc_index_define t1 --指标定义表 
INNER JOIN itl_edw_cass_R_RPT_RST0015 t2 --报表-管驾明细表 
 on t2.etl_dt=to_date('${last_month_end}','yyyymmdd')
and t2.index_level3_class = t1.index_name_mcs
--and t2.index_level1_class = t1.index_clsaa_s_mcs
--and t2.index_level2_class = t1.index_clsaa_t_mcs
INNER JOIN mtl_cmm_intnal_org_info t3 --None 
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
,t2.STD_PRO_NO
,t2.STD_PRO_NAME
,t1.unit;
commit;

/*==============第4.3组==============*/

--临时表01:三级指标-当月-全行-产品
insert into ${idl_schema}.tmp_mc_adac_ind_ranking_dtl_01(
    etl_dt                                                       --ETL处理日期
    ,curr_no                                                     --币种编号
    ,curr_name                                                   --币种名称
    ,index_no                                                    --指标编号
    ,index_name                                                  --指标名称
    -- 5
    ,org_no                                                      --机构编号
    ,org_name                                                    --机构名称
    ,super_org_no                                                --上级机构编号
    ,dimen_obj_id                                                --维度对象编号
    ,dimen_obj_name                                              --维度对象名称
    -- 10    
    ,index_value_m                                               --当月指标值
    ,index_value_y                                               --当年指标值
    ,ranking_dimen_id                                            --排行维度编号(001分行002支行团队003客户经理004产品)
    ,ranking_dimen_name                                          --排行维度名称
    ,unit                                                        --单位
    -- 15
)
select
    to_date('${last_month_end}','yyyymmdd') as etl_dt                --None
    ,t2.CURR_CD as curr_no                                       --None
    ,t2.CURR_NAME as curr_name                                   --None
    ,t1.index_no_mcs as index_no                                 --None
    ,t1.index_name_mcs as index_name                             --None
    -- 5
    ,'000000' as org_no                                    --None
    ,'全行' as org_name                             --None
    ,'999999' as super_org_no                  --None
    ,t2.STD_PRO_NO as dimen_obj_id                               --None
    ,t2.STD_PRO_NAME as dimen_obj_name                           --None
    -- 10
    ,case when t1.UNIT ='%' and sum(t2.KPI_VALUE_MOM)>0 then SUM(T2.KPI_VALUE_MM)/SUM(t2.KPI_VALUE_MOM)/extract(day from last_day(to_date('${last_month_end}','yyyymmdd')))*(add_months(trunc(to_date('${last_month_end}','yyyymmdd'),'yyyy'),12)-trunc(to_date('${last_month_end}','yyyymmdd'),'yyyy'))
     when t1.UNIT ='%' and sum(t2.KPI_VALUE_MOM)=0 then 0
     else SUM(t2.KPI_VALUE_M)
end as index_value_m --None
    ,case when t1.UNIT ='%' and sum(t2.KPI_VALUE_YOY)>0 then SUM(T2.KPI_VALUE_YY)/SUM(t2.KPI_VALUE_YOY)/(to_date('${last_month_end}','yyyymmdd')-decode(substr('${last_month_end}',5,4),'1231',to_date('${last_year_start}','yyyymmdd'),to_date('${year_start}','yyyymmdd'))+1)*(add_months(trunc(to_date('${last_month_end}','yyyymmdd'),'yyyy'),12)-trunc(to_date('${last_month_end}','yyyymmdd'),'yyyy'))

     when t1.UNIT ='%' and sum(t2.KPI_VALUE_YOY)=0 then 0
     else SUM(t2.KPI_VALUE_Y)
end as index_value_y --None
    ,'004' as ranking_dimen_id                                   --None
    ,'产品' as ranking_dimen_name                                  --None
    ,t1.unit as unit                                             --None
    -- 15
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
,t2.STD_PRO_NO
,t2.STD_PRO_NAME
,t1.unit;
commit;

/*==============第5组==============*/

--临时表01:二级指标-分行
insert into ${idl_schema}.tmp_mc_adac_ind_ranking_dtl_01(
    etl_dt                                                       --ETL处理日期
    ,curr_no                                                     --币种编号
    ,curr_name                                                   --币种名称
    ,index_no                                                    --指标编号
    ,index_name                                                  --指标名称
    -- 5
    ,org_no                                                      --机构编号
    ,org_name                                                    --机构名称
    ,super_org_no                                                --上级机构编号
    ,dimen_obj_id                                                --维度对象编号
    ,dimen_obj_name                                              --维度对象名称
    -- 10
    ,index_value_m                                               --当月指标值
    ,index_value_y                                               --当年指标值
    ,ranking_dimen_id                                            --排行维度编号(001分行002支行团队003客户经理004产品)
    ,ranking_dimen_name                                          --排行维度名称
    ,unit                                                        --单位
    -- 15
)
select
    to_date('${last_month_end}','yyyymmdd') as etl_dt                --None
    ,t2.CURR_CD as curr_no                                       --None
    ,t2.CURR_NAME as curr_name                                   --None
    ,t1.index_no_mcs as index_no                                 --None
    ,t1.index_name_mcs as index_name                             --None
    -- 5
    ,substr(t2.MANAGER_ORG,1,3) as org_no                        --None
    ,t5.ORG_NAME as org_name                                     --None
    ,'000000' as super_org_no                                    --None
    ,substr(t2.MANAGER_ORG,1,3) as dimen_obj_id                  --None
    ,t5.ORG_ABBR as dimen_obj_name                               --None
    -- 10
    ,case when t1.UNIT ='%'  then nvl(max(t3.kpi_value_m_dk),0)-nvl(max(t4.kpi_value_m_ck),0)
     else SUM(t2.KPI_VALUE_M)
     end as kpi_value_m --当月值
		,case when t1.UNIT ='%'  then nvl(max(t3.kpi_value_y_dk),0)-nvl(max(t4.kpi_value_y_ck),0)
     else SUM(t2.KPI_VALUE_Y)
     end as kpi_value_y --当年值
    ,'001' as ranking_dimen_id                                   --None
    ,'分行' as ranking_dimen_name                                  --None
    ,t1.unit as unit                                             --None
    -- 15
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
INNER JOIN mtl_cmm_intnal_org_info t5 --None 
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
,t5.ORG_ABBR
,t1.unit;
commit;


/*==============第6组==============*/

--临时表01:二级指标-当月-支行
insert into ${idl_schema}.tmp_mc_adac_ind_ranking_dtl_01(
    etl_dt                                                       --ETL处理日期
    ,curr_no                                                     --币种编号
    ,curr_name                                                   --币种名称
    ,index_no                                                    --指标编号
    ,index_name                                                  --指标名称
    -- 5
    ,org_no                                                      --机构编号
    ,org_name                                                    --机构名称
    ,super_org_no                                                --上级机构编号
    ,dimen_obj_id                                                --维度对象编号
    ,dimen_obj_name                                              --维度对象名称
    -- 10
    ,index_value_m                                               --当月指标值
    ,index_value_y                                               --当年指标值
    ,ranking_dimen_id                                            --排行维度编号(001分行002支行团队003客户经理004产品)
    ,ranking_dimen_name                                          --排行维度名称
    ,unit                                                        --单位
    -- 15
)
select
    to_date('${last_month_end}','yyyymmdd') as etl_dt                --None
    ,t2.CURR_CD as curr_no                                       --None
    ,t2.CURR_NAME as curr_name                                   --None
    ,t1.index_no_mcs as index_no                                 --None
    ,t1.index_name_mcs as index_name                             --None
    -- 5
    ,t2.MANAGER_ORG as org_no                                    --None
    ,t2.MANAGER_ORG_NAME as org_name                             --None
    ,substr(t2.MANAGER_ORG,1,3) as super_org_no                  --None
    ,t2.MANAGER_ORG as dimen_obj_id                              --None
    ,t5.ORG_NAME as dimen_obj_name                               --None
    -- 10
    ,case when t1.UNIT ='%'  then nvl(max(t3.kpi_value_m_dk),0)-nvl(max(t4.kpi_value_m_ck),0)
     else SUM(t2.KPI_VALUE_M)
     end as kpi_value_m --当月值
		,case when t1.UNIT ='%'  then nvl(max(t3.kpi_value_y_dk),0)-nvl(max(t4.kpi_value_y_ck),0)
     else SUM(t2.KPI_VALUE_Y)
     end as kpi_value_y --当年值
    ,'002' as ranking_dimen_id                                   --None
    ,'支行团队' as ranking_dimen_name                                --None
    ,t1.unit as unit                                             --None
    -- 15
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
INNER JOIN mtl_cmm_intnal_org_info t5 --None 
 on t5.etl_dt=to_date('${last_month_end}','yyyymmdd')
and t5.ORG_ID=t2.MANAGER_ORG
where t1.source_system='数仓-管会'
and substr(t1.index_no_mcs,length(t1.index_no_mcs)-1,2)='00'
and substr(t1.index_no_mcs,length(t1.index_no_mcs)-4,2)<>'00' --二级指标
GROUP BY t2.CURR_CD
,t2.CURR_NAME
,t1.index_no_mcs
,t1.index_name_mcs
,t2.MANAGER_ORG
,t2.MANAGER_ORG_NAME
,substr(t2.MANAGER_ORG,1,3)
,t2.MANAGER_ORG
,t5.ORG_NAME
,t1.unit;
commit;


/*==============第7组==============*/

--临时表01:二级指标-当月-客户经理
insert into ${idl_schema}.tmp_mc_adac_ind_ranking_dtl_01(
    etl_dt                                                       --ETL处理日期
    ,curr_no                                                     --币种编号
    ,curr_name                                                   --币种名称
    ,index_no                                                    --指标编号
    ,index_name                                                  --指标名称
    -- 5
    ,org_no                                                      --机构编号
    ,org_name                                                    --机构名称
    ,super_org_no                                                --上级机构编号
    ,dimen_obj_id                                                --维度对象编号
    ,dimen_obj_name                                              --维度对象名称
    -- 10
    ,index_value_m                                               --当月指标值
    ,index_value_y                                               --当年指标值
    ,ranking_dimen_id                                            --排行维度编号(001分行002支行团队003客户经理004产品)
    ,ranking_dimen_name                                          --排行维度名称
    ,unit                                                        --单位
    -- 15
)
select
    to_date('${last_month_end}','yyyymmdd') as etl_dt                --None
    ,t2.CURR_CD as curr_no                                       --None
    ,t2.CURR_NAME as curr_name                                   --None
    ,t1.index_no_mcs as index_no                                 --None
    ,t1.index_name_mcs as index_name                             --None
    -- 5
    ,t2.MANAGER_ORG as org_no                                    --None
    ,t2.MANAGER_ORG_NAME as org_name                             --None
    ,substr(t2.MANAGER_ORG,1,3) as super_org_no                  --None
    ,t2.CUST_MGR_NO as dimen_obj_id                              --None
    ,t2.CUST_MGR_NAME as dimen_obj_name                          --None
    -- 10
    ,case when t1.UNIT ='%'  then nvl(max(t3.kpi_value_m_dk),0)-nvl(max(t4.kpi_value_m_ck),0)
     else SUM(t2.KPI_VALUE_M)
     end as kpi_value_m --当月值
		,case when t1.UNIT ='%'  then nvl(max(t3.kpi_value_y_dk),0)-nvl(max(t4.kpi_value_y_ck),0)
     else SUM(t2.KPI_VALUE_Y)
     end as kpi_value_y --当年值
    ,'003' as ranking_dimen_id                                   --None
    ,'客户经理' as ranking_dimen_name                                --None
    ,t1.unit as unit                                             --None
    -- 15
 from mc_index_define t1 --指标定义表 
INNER JOIN itl_edw_cass_R_RPT_RST0015 t2 --报表-管驾明细表 
 on t2.etl_dt=to_date('${last_month_end}','yyyymmdd')
and t2.index_level1_class = t1.index_clsaa_s_mcs
and t2.index_level2_class = t1.index_clsaa_t_mcs
and t2.CUST_MGR_NO not like 'XN%'
and trim(t2.CUST_MGR_NO) is not null
and t2.CUST_MGR_NO <>'DEF'
left JOIN (select case when SUM(t31.KPI_VALUE_MOM)=0 then 0 else SUM(t31.KPI_VALUE_MM)/SUM(t31.KPI_VALUE_MOM)/extract(day from last_day(to_date('${last_month_end}','yyyymmdd')))*(add_months(trunc(to_date('${last_month_end}','yyyymmdd'),'yyyy'),12)-trunc(to_date('${last_month_end}','yyyymmdd'),'yyyy')) end as kpi_value_m_dk
                 ,case when SUM(t31.KPI_VALUE_YOY)=0 then 0 else SUM(t31.KPI_VALUE_YY)/SUM(t31.KPI_VALUE_YOY)/(to_date('${last_month_end}','yyyymmdd')-decode(substr('${last_month_end}',5,4),'1231',to_date('${last_year_start}','yyyymmdd'),to_date('${year_start}','yyyymmdd'))+1)*(add_months(trunc(to_date('${last_month_end}','yyyymmdd'),'yyyy'),12)-trunc(to_date('${last_month_end}','yyyymmdd'),'yyyy')) end as kpi_value_y_dk
                 ,t31.CURR_CD,t31.index_level2_class,t31.CUST_MGR_NO
                from itl_edw_cass_R_RPT_RST0015 t31 --报表-管驾明细表 
               where t31.etl_dt=to_date('${last_month_end}','yyyymmdd')
                and t31.index_level1_class = '存贷利差'            
                and substr(t31.COM_LINE_NAME,length(t31.COM_LINE_NAME)-1)='贷款'
                and t31.CUST_MGR_NO not like 'XN%'
                and trim(t31.CUST_MGR_NO) is not null
				and t31.CUST_MGR_NO <>'DEF'
                group by t31.CURR_CD,t31.index_level2_class,t31.CUST_MGR_NO) t3
  on  t3.CURR_CD = t2.CURR_CD
  and t3.index_level2_class = t1.index_clsaa_t_mcs
  and t3.CUST_MGR_NO=t2.CUST_MGR_NO
left JOIN (select case when SUM(t41.KPI_VALUE_MOM)=0 then 0 else SUM(t41.KPI_VALUE_MM)/SUM(t41.KPI_VALUE_MOM)/extract(day from last_day(to_date('${last_month_end}','yyyymmdd')))*(add_months(trunc(to_date('${last_month_end}','yyyymmdd'),'yyyy'),12)-trunc(to_date('${last_month_end}','yyyymmdd'),'yyyy')) end as kpi_value_m_ck
                 ,case when SUM(t41.KPI_VALUE_YOY)=0 then 0 else SUM(t41.KPI_VALUE_YY)/SUM(t41.KPI_VALUE_YOY)/(to_date('${last_month_end}','yyyymmdd')-decode(substr('${last_month_end}',5,4),'1231',to_date('${last_year_start}','yyyymmdd'),to_date('${year_start}','yyyymmdd'))+1)*(add_months(trunc(to_date('${last_month_end}','yyyymmdd'),'yyyy'),12)-trunc(to_date('${last_month_end}','yyyymmdd'),'yyyy')) end as kpi_value_y_ck
                 ,t41.CURR_CD,t41.index_level2_class,t41.CUST_MGR_NO
                from itl_edw_cass_R_RPT_RST0015 t41 --报表-管驾明细表 
               where t41.etl_dt=to_date('${last_month_end}','yyyymmdd')
                and t41.index_level1_class = '存贷利差'            
                and substr(t41.COM_LINE_NAME,length(t41.COM_LINE_NAME)-1)='存款'
                and t41.CUST_MGR_NO not like 'XN%'
                and trim(t41.CUST_MGR_NO) is not null
				and t41.CUST_MGR_NO <>'DEF'
                group by t41.CURR_CD,t41.index_level2_class,t41.CUST_MGR_NO) t4
  on  t4.CURR_CD = t2.CURR_CD
  and t4.index_level2_class = t1.index_clsaa_t_mcs
  and t4.CUST_MGR_NO=t2.CUST_MGR_NO
INNER JOIN mtl_cmm_intnal_org_info t5 --None 
 on t5.etl_dt=to_date('${last_month_end}','yyyymmdd')
and t5.ORG_ID=t2.MANAGER_ORG
where t1.source_system='数仓-管会'
and substr(t1.index_no_mcs,length(t1.index_no_mcs)-1,2)='00'
and substr(t1.index_no_mcs,length(t1.index_no_mcs)-4,2)<>'00' --二级指标
GROUP BY t2.CURR_CD
,t2.CURR_NAME
,t1.index_no_mcs
,t1.index_name_mcs
,substr(t2.MANAGER_ORG,1,3)
,t2.MANAGER_ORG
,t2.MANAGER_ORG_NAME
,t5.ORG_NAME
,t2.CUST_MGR_NO
,t2.CUST_MGR_NAME
,t1.unit;
commit;


/*==============第8.1组==============*/

--临时表01:二级指标-当月-支行-产品
insert into ${idl_schema}.tmp_mc_adac_ind_ranking_dtl_01(
    etl_dt                                                       --ETL处理日期
    ,curr_no                                                     --币种编号
    ,curr_name                                                   --币种名称
    ,index_no                                                    --指标编号
    ,index_name                                                  --指标名称
    -- 5
    ,org_no                                                      --机构编号
    ,org_name                                                    --机构名称
    ,super_org_no                                                --上级机构编号
    ,dimen_obj_id                                                --维度对象编号
    ,dimen_obj_name                                              --维度对象名称
    -- 10
    ,index_value_m                                               --当月指标值
    ,index_value_y                                               --当年指标值
    ,ranking_dimen_id                                            --排行维度编号(001分行002支行团队003客户经理004产品)
    ,ranking_dimen_name                                          --排行维度名称
    ,unit                                                        --单位
    -- 15
)
select
    to_date('${last_month_end}','yyyymmdd') as etl_dt                --None
    ,t2.CURR_CD as curr_no                                       --None
    ,t2.CURR_NAME as curr_name                                   --None
    ,t1.index_no_mcs as index_no                                 --None
    ,t1.index_name_mcs as index_name                             --None
    -- 5
    ,t2.MANAGER_ORG as org_no                                    --None
    ,t2.MANAGER_ORG_NAME as org_name                             --None
    ,substr(t2.MANAGER_ORG,1,3) as super_org_no                  --None
    ,t2.STD_PRO_NO as dimen_obj_id                               --None
    ,t2.STD_PRO_NAME as dimen_obj_name                           --None
    -- 10
    ,case when t1.UNIT ='%'  then nvl(max(t3.kpi_value_m_dk),0)-nvl(max(t4.kpi_value_m_ck),0)
     else SUM(t2.KPI_VALUE_M)
     end as kpi_value_m --当月值
		,case when t1.UNIT ='%'  then nvl(max(t3.kpi_value_y_dk),0)-nvl(max(t4.kpi_value_y_ck),0)
     else SUM(t2.KPI_VALUE_Y)
     end as kpi_value_y --当年值
    ,'004' as ranking_dimen_id                                   --None
    ,'产品' as ranking_dimen_name                                  --None
    ,t1.unit as unit                                             --None
    -- 15
 from mc_index_define t1 --指标定义表 
INNER JOIN itl_edw_cass_R_RPT_RST0015 t2 --报表-管驾明细表 
 on t2.etl_dt=to_date('${last_month_end}','yyyymmdd')
and t2.index_level1_class = t1.index_clsaa_s_mcs
and t2.index_level2_class = t1.index_clsaa_t_mcs
and length(t2.MANAGER_ORG)>3
and t2.MANAGER_ORG<>'000000'
left JOIN (select case when SUM(t31.KPI_VALUE_MOM)=0 then 0 else SUM(t31.KPI_VALUE_MM)/SUM(t31.KPI_VALUE_MOM)/extract(day from last_day(to_date('${last_month_end}','yyyymmdd')))*(add_months(trunc(to_date('${last_month_end}','yyyymmdd'),'yyyy'),12)-trunc(to_date('${last_month_end}','yyyymmdd'),'yyyy')) end as kpi_value_m_dk
                 ,case when SUM(t31.KPI_VALUE_YOY)=0 then 0 else SUM(t31.KPI_VALUE_YY)/SUM(t31.KPI_VALUE_YOY)/(to_date('${last_month_end}','yyyymmdd')-decode(substr('${last_month_end}',5,4),'1231',to_date('${last_year_start}','yyyymmdd'),to_date('${year_start}','yyyymmdd'))+1)*(add_months(trunc(to_date('${last_month_end}','yyyymmdd'),'yyyy'),12)-trunc(to_date('${last_month_end}','yyyymmdd'),'yyyy')) end as kpi_value_y_dk
                 ,t31.CURR_CD,t31.index_level2_class,t31.STD_PRO_NO,t31.MANAGER_ORG
                from itl_edw_cass_R_RPT_RST0015 t31 --报表-管驾明细表 
               where t31.etl_dt=to_date('${last_month_end}','yyyymmdd')
                and t31.index_level1_class = '存贷利差'            
                and substr(t31.COM_LINE_NAME,length(t31.COM_LINE_NAME)-1)='贷款'
                and t31.CUST_MGR_NO not like 'XN%'
                group by t31.CURR_CD,t31.index_level2_class,t31.STD_PRO_NO,t31.MANAGER_ORG) t3
  on  t3.CURR_CD = t2.CURR_CD
  and t3.index_level2_class = t1.index_clsaa_t_mcs
  and t3.STD_PRO_NO=t2.STD_PRO_NO
  and t3.MANAGER_ORG=t2.MANAGER_ORG
left JOIN (select case when SUM(t41.KPI_VALUE_MOM)=0 then 0 else SUM(t41.KPI_VALUE_MM)/SUM(t41.KPI_VALUE_MOM)/extract(day from last_day(to_date('${last_month_end}','yyyymmdd')))*(add_months(trunc(to_date('${last_month_end}','yyyymmdd'),'yyyy'),12)-trunc(to_date('${last_month_end}','yyyymmdd'),'yyyy')) end as kpi_value_m_ck
                 ,case when SUM(t41.KPI_VALUE_YOY)=0 then 0 else SUM(t41.KPI_VALUE_YY)/SUM(t41.KPI_VALUE_YOY)/(to_date('${last_month_end}','yyyymmdd')-decode(substr('${last_month_end}',5,4),'1231',to_date('${last_year_start}','yyyymmdd'),to_date('${year_start}','yyyymmdd'))+1)*(add_months(trunc(to_date('${last_month_end}','yyyymmdd'),'yyyy'),12)-trunc(to_date('${last_month_end}','yyyymmdd'),'yyyy')) end as kpi_value_y_ck
                 ,t41.CURR_CD,t41.index_level2_class,t41.STD_PRO_NO,t41.MANAGER_ORG
                from itl_edw_cass_R_RPT_RST0015 t41 --报表-管驾明细表 
               where t41.etl_dt=to_date('${last_month_end}','yyyymmdd')
                and t41.index_level1_class = '存贷利差'            
                and substr(t41.COM_LINE_NAME,length(t41.COM_LINE_NAME)-1)='存款'
                and t41.CUST_MGR_NO not like 'XN%'
                group by t41.CURR_CD,t41.index_level2_class,t41.STD_PRO_NO,t41.MANAGER_ORG) t4
  on  t4.CURR_CD = t2.CURR_CD
  and t4.index_level2_class = t1.index_clsaa_t_mcs
  and t4.STD_PRO_NO=t2.STD_PRO_NO
  and t4.MANAGER_ORG=t2.MANAGER_ORG
INNER JOIN mtl_cmm_intnal_org_info t5 --None 
 on t5.etl_dt=to_date('${last_month_end}','yyyymmdd')
and t5.ORG_ID=t2.MANAGER_ORG
where t1.source_system='数仓-管会'
and substr(t1.index_no_mcs,length(t1.index_no_mcs)-1,2)='00'
and substr(t1.index_no_mcs,length(t1.index_no_mcs)-4,2)<>'00' --二级指标
GROUP BY t2.CURR_CD
,t2.CURR_NAME
,t1.index_no_mcs
,t1.index_name_mcs
,substr(t2.MANAGER_ORG,1,3)
,t2.MANAGER_ORG
,t2.MANAGER_ORG_NAME
,t5.ORG_NAME
,t2.STD_PRO_NO
,t2.STD_PRO_NAME
,t1.unit;
commit;

/*==============第8.2组==============*/

--临时表01:二级指标-当月-分行-产品
insert into ${idl_schema}.tmp_mc_adac_ind_ranking_dtl_01(
    etl_dt                                                       --ETL处理日期
    ,curr_no                                                     --币种编号
    ,curr_name                                                   --币种名称
    ,index_no                                                    --指标编号
    ,index_name                                                  --指标名称
    -- 5
    ,org_no                                                      --机构编号
    ,org_name                                                    --机构名称
    ,super_org_no                                                --上级机构编号
    ,dimen_obj_id                                                --维度对象编号
    ,dimen_obj_name                                              --维度对象名称
    -- 10
    ,index_value_m                                               --当月指标值
    ,index_value_y                                               --当年指标值
    ,ranking_dimen_id                                            --排行维度编号(001分行002支行团队003客户经理004产品)
    ,ranking_dimen_name                                          --排行维度名称
    ,unit                                                        --单位
    -- 15
)
select
    to_date('${last_month_end}','yyyymmdd') as etl_dt                --None
    ,t2.CURR_CD as curr_no                                       --None
    ,t2.CURR_NAME as curr_name                                   --None
    ,t1.index_no_mcs as index_no                                 --None
    ,t1.index_name_mcs as index_name                             --None
    -- 5
    ,substr(t2.MANAGER_ORG,1,3) as org_no                                    --None
    ,t5.ORG_NAME as org_name                             --None
    ,'000000' as super_org_no                  --None
    ,t2.STD_PRO_NO as dimen_obj_id                               --None
    ,t2.STD_PRO_NAME as dimen_obj_name                           --None
    -- 10
    ,case when t1.UNIT ='%'  then nvl(max(t3.kpi_value_m_dk),0)-nvl(max(t4.kpi_value_m_ck),0)
     else SUM(t2.KPI_VALUE_M)
     end as kpi_value_m --当月值
		,case when t1.UNIT ='%'  then nvl(max(t3.kpi_value_y_dk),0)-nvl(max(t4.kpi_value_y_ck),0)
     else SUM(t2.KPI_VALUE_Y)
     end as kpi_value_y --当年值
    ,'004' as ranking_dimen_id                                   --None
    ,'产品' as ranking_dimen_name                                  --None
    ,t1.unit as unit                                             --None
    -- 15
 from mc_index_define t1 --指标定义表 
INNER JOIN itl_edw_cass_R_RPT_RST0015 t2 --报表-管驾明细表 
 on t2.etl_dt=to_date('${last_month_end}','yyyymmdd')
and t2.index_level1_class = t1.index_clsaa_s_mcs
and t2.index_level2_class = t1.index_clsaa_t_mcs
left JOIN (select case when SUM(t31.KPI_VALUE_MOM)=0 then 0 else SUM(t31.KPI_VALUE_MM)/SUM(t31.KPI_VALUE_MOM)/extract(day from last_day(to_date('${last_month_end}','yyyymmdd')))*(add_months(trunc(to_date('${last_month_end}','yyyymmdd'),'yyyy'),12)-trunc(to_date('${last_month_end}','yyyymmdd'),'yyyy')) end as kpi_value_m_dk
                 ,case when SUM(t31.KPI_VALUE_YOY)=0 then 0 else SUM(t31.KPI_VALUE_YY)/SUM(t31.KPI_VALUE_YOY)/(to_date('${last_month_end}','yyyymmdd')-decode(substr('${last_month_end}',5,4),'1231',to_date('${last_year_start}','yyyymmdd'),to_date('${year_start}','yyyymmdd'))+1)*(add_months(trunc(to_date('${last_month_end}','yyyymmdd'),'yyyy'),12)-trunc(to_date('${last_month_end}','yyyymmdd'),'yyyy')) end as kpi_value_y_dk
                 ,t31.CURR_CD,t31.index_level2_class,t31.STD_PRO_NO,substr(t31.MANAGER_ORG,1,3) as MANAGER_ORG
                from itl_edw_cass_R_RPT_RST0015 t31 --报表-管驾明细表 
               where t31.etl_dt=to_date('${last_month_end}','yyyymmdd')
                and t31.index_level1_class = '存贷利差'            
                and substr(t31.COM_LINE_NAME,length(t31.COM_LINE_NAME)-1)='贷款'
                and t31.CUST_MGR_NO not like 'XN%'
                group by t31.CURR_CD,t31.index_level2_class,t31.STD_PRO_NO,substr(t31.MANAGER_ORG,1,3)) t3
  on  t3.CURR_CD = t2.CURR_CD
  and t3.index_level2_class = t1.index_clsaa_t_mcs
  and t3.STD_PRO_NO=t2.STD_PRO_NO
  and t3.MANAGER_ORG=substr(t2.MANAGER_ORG,1,3)
left JOIN (select case when SUM(t41.KPI_VALUE_MOM)=0 then 0 else SUM(t41.KPI_VALUE_MM)/SUM(t41.KPI_VALUE_MOM)/extract(day from last_day(to_date('${last_month_end}','yyyymmdd')))*(add_months(trunc(to_date('${last_month_end}','yyyymmdd'),'yyyy'),12)-trunc(to_date('${last_month_end}','yyyymmdd'),'yyyy')) end as kpi_value_m_ck
                 ,case when SUM(t41.KPI_VALUE_YOY)=0 then 0 else SUM(t41.KPI_VALUE_YY)/SUM(t41.KPI_VALUE_YOY)/(to_date('${last_month_end}','yyyymmdd')-decode(substr('${last_month_end}',5,4),'1231',to_date('${last_year_start}','yyyymmdd'),to_date('${year_start}','yyyymmdd'))+1)*(add_months(trunc(to_date('${last_month_end}','yyyymmdd'),'yyyy'),12)-trunc(to_date('${last_month_end}','yyyymmdd'),'yyyy')) end as kpi_value_y_ck
                 ,t41.CURR_CD,t41.index_level2_class,t41.STD_PRO_NO,substr(t41.MANAGER_ORG,1,3) as MANAGER_ORG
                from itl_edw_cass_R_RPT_RST0015 t41 --报表-管驾明细表 
               where t41.etl_dt=to_date('${last_month_end}','yyyymmdd')
                and t41.index_level1_class = '存贷利差'            
                and substr(t41.COM_LINE_NAME,length(t41.COM_LINE_NAME)-1)='存款'
                and t41.CUST_MGR_NO not like 'XN%'
                group by t41.CURR_CD,t41.index_level2_class,t41.STD_PRO_NO,substr(t41.MANAGER_ORG,1,3)) t4
  on  t4.CURR_CD = t2.CURR_CD
  and t4.index_level2_class = t1.index_clsaa_t_mcs
  and t4.STD_PRO_NO=t2.STD_PRO_NO
  and t4.MANAGER_ORG=substr(t2.MANAGER_ORG,1,3)
INNER JOIN mtl_cmm_intnal_org_info t5 --None 
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
,t2.STD_PRO_NO
,t2.STD_PRO_NAME
,t1.unit;
commit;

/*==============第8.3组==============*/

--临时表01:二级指标-当月-全行-产品
insert into ${idl_schema}.tmp_mc_adac_ind_ranking_dtl_01(
    etl_dt                                                       --ETL处理日期
    ,curr_no                                                     --币种编号
    ,curr_name                                                   --币种名称
    ,index_no                                                    --指标编号
    ,index_name                                                  --指标名称
    -- 5
    ,org_no                                                      --机构编号
    ,org_name                                                    --机构名称
    ,super_org_no                                                --上级机构编号
    ,dimen_obj_id                                                --维度对象编号
    ,dimen_obj_name                                              --维度对象名称
    -- 10
    ,index_value_m                                               --当月指标值
    ,index_value_y                                               --当年指标值
    ,ranking_dimen_id                                            --排行维度编号(001分行002支行团队003客户经理004产品)
    ,ranking_dimen_name                                          --排行维度名称
    ,unit                                                        --单位
    -- 15
)
select
    to_date('${last_month_end}','yyyymmdd') as etl_dt                --None
    ,t2.CURR_CD as curr_no                                       --None
    ,t2.CURR_NAME as curr_name                                   --None
    ,t1.index_no_mcs as index_no                                 --None
    ,t1.index_name_mcs as index_name                             --None
    -- 5
    ,'000000' as org_no                                    --None
    ,'全行' as org_name                             --None
    ,'999999' as super_org_no                  --None
    ,t2.STD_PRO_NO as dimen_obj_id                               --None
    ,t2.STD_PRO_NAME as dimen_obj_name                           --None
    -- 10
    ,case when t1.UNIT ='%'  then nvl(sum(t3.kpi_value_m_dk),0)-nvl(sum(t4.kpi_value_m_ck),0)
     else SUM(t2.KPI_VALUE_M)
     end as kpi_value_m --当月值
		,case when t1.UNIT ='%'  then nvl(sum(t3.kpi_value_y_dk),0)-nvl(sum(t4.kpi_value_y_ck),0)
     else SUM(t2.KPI_VALUE_Y)
     end as kpi_value_y --当年值
    ,'004' as ranking_dimen_id                                   --None
    ,'产品' as ranking_dimen_name                                  --None
    ,t1.unit as unit                                             --None
    -- 15
 from mc_index_define t1 --指标定义表 
INNER JOIN itl_edw_cass_R_RPT_RST0015 t2 --报表-管驾明细表 
 on t2.etl_dt=to_date('${last_month_end}','yyyymmdd')
and t2.index_level1_class = t1.index_clsaa_s_mcs
and t2.index_level2_class = t1.index_clsaa_t_mcs
left JOIN (select case when SUM(t31.KPI_VALUE_MOM)=0 then 0 else SUM(t31.KPI_VALUE_MM)/SUM(t31.KPI_VALUE_MOM)/extract(day from last_day(to_date('${last_month_end}','yyyymmdd')))*(add_months(trunc(to_date('${last_month_end}','yyyymmdd'),'yyyy'),12)-trunc(to_date('${last_month_end}','yyyymmdd'),'yyyy')) end as kpi_value_m_dk
                 ,case when SUM(t31.KPI_VALUE_YOY)=0 then 0 else SUM(t31.KPI_VALUE_YY)/SUM(t31.KPI_VALUE_YOY)/(to_date('${last_month_end}','yyyymmdd')-decode(substr('${last_month_end}',5,4),'1231',to_date('${last_year_start}','yyyymmdd'),to_date('${year_start}','yyyymmdd'))+1)*(add_months(trunc(to_date('${last_month_end}','yyyymmdd'),'yyyy'),12)-trunc(to_date('${last_month_end}','yyyymmdd'),'yyyy')) end as kpi_value_y_dk
                 ,t31.CURR_CD,t31.index_level2_class,t31.STD_PRO_NO
                from itl_edw_cass_R_RPT_RST0015 t31 --报表-管驾明细表 
               where t31.etl_dt=to_date('${last_month_end}','yyyymmdd')
                and t31.index_level1_class = '存贷利差'            
                and substr(t31.COM_LINE_NAME,length(t31.COM_LINE_NAME)-1)='贷款'
                and t31.CUST_MGR_NO not like 'XN%'
                group by t31.CURR_CD,t31.index_level2_class,t31.STD_PRO_NO) t3
  on  t3.CURR_CD = t2.CURR_CD
  and t3.index_level2_class = t1.index_clsaa_t_mcs
  and t3.STD_PRO_NO=t2.STD_PRO_NO
left JOIN (select case when SUM(t41.KPI_VALUE_MOM)=0 then 0 else SUM(t41.KPI_VALUE_MM)/SUM(t41.KPI_VALUE_MOM)/extract(day from last_day(to_date('${last_month_end}','yyyymmdd')))*(add_months(trunc(to_date('${last_month_end}','yyyymmdd'),'yyyy'),12)-trunc(to_date('${last_month_end}','yyyymmdd'),'yyyy')) end as kpi_value_m_ck
                 ,case when SUM(t41.KPI_VALUE_YOY)=0 then 0 else SUM(t41.KPI_VALUE_YY)/SUM(t41.KPI_VALUE_YOY)/(to_date('${last_month_end}','yyyymmdd')-decode(substr('${last_month_end}',5,4),'1231',to_date('${last_year_start}','yyyymmdd'),to_date('${year_start}','yyyymmdd'))+1)*(add_months(trunc(to_date('${last_month_end}','yyyymmdd'),'yyyy'),12)-trunc(to_date('${last_month_end}','yyyymmdd'),'yyyy')) end as kpi_value_y_ck
                 ,t41.CURR_CD,t41.index_level2_class,t41.STD_PRO_NO
                from itl_edw_cass_R_RPT_RST0015 t41 --报表-管驾明细表 
               where t41.etl_dt=to_date('${last_month_end}','yyyymmdd')
                and t41.index_level1_class = '存贷利差'            
                and substr(t41.COM_LINE_NAME,length(t41.COM_LINE_NAME)-1)='存款'
                and t41.CUST_MGR_NO not like 'XN%'
                group by t41.CURR_CD,t41.index_level2_class,t41.STD_PRO_NO) t4
  on  t4.CURR_CD = t2.CURR_CD
  and t4.index_level2_class = t1.index_clsaa_t_mcs
  and t4.STD_PRO_NO=t2.STD_PRO_NO
where t1.source_system='数仓-管会'
and substr(t1.index_no_mcs,length(t1.index_no_mcs)-1,2)='00'
and substr(t1.index_no_mcs,length(t1.index_no_mcs)-4,2)<>'00' --二级指标
GROUP BY t2.CURR_CD
,t2.CURR_NAME
,t1.index_no_mcs
,t1.index_name_mcs
,t2.STD_PRO_NO
,t2.STD_PRO_NAME
,t1.unit;
commit;

/*==============第9组==============*/

--临时表01:一级指标-分行
insert into ${idl_schema}.tmp_mc_adac_ind_ranking_dtl_01(
    etl_dt                                                       --ETL处理日期
    ,curr_no                                                     --币种编号
    ,curr_name                                                   --币种名称
    ,index_no                                                    --指标编号
    ,index_name                                                  --指标名称
    -- 5
    ,org_no                                                      --机构编号
    ,org_name                                                    --机构名称
    ,super_org_no                                                --上级机构编号
    ,dimen_obj_id                                                --维度对象编号
    ,dimen_obj_name                                              --维度对象名称
    -- 10
    ,index_value_m                                               --当月指标值
    ,index_value_y                                               --当年指标值
    ,ranking_dimen_id                                            --排行维度编号(001分行002支行团队003客户经理004产品)
    ,ranking_dimen_name                                          --排行维度名称
    ,unit                                                        --单位
    -- 15
)
select
    to_date('${last_month_end}','yyyymmdd') as etl_dt                --None
    ,t2.CURR_CD as curr_no                                       --None
    ,t2.CURR_NAME as curr_name                                   --None
    ,t1.index_no_mcs as index_no                                 --None
    ,t1.index_name_mcs as index_name                             --None
    -- 5
    ,substr(t2.MANAGER_ORG,1,3) as org_no                        --None
    ,t5.ORG_NAME as org_name                                     --None
    ,'000000' as super_org_no                                    --None
    ,substr(t2.MANAGER_ORG,1,3) as dimen_obj_id                  --None
    ,t5.ORG_ABBR as dimen_obj_name                               --None
    -- 10
    ,case when t1.UNIT ='%'  then nvl(max(t3.kpi_value_m_dk),0)-nvl(max(t4.kpi_value_m_ck),0)
     else SUM(t2.KPI_VALUE_M) 
     end as kpi_value_m --当月值
		,case when t1.UNIT ='%'  then nvl(max(t3.kpi_value_y_dk),0)-nvl(max(t4.kpi_value_y_ck),0)
     else SUM(t2.KPI_VALUE_Y)
     end as kpi_value_y --当年值
    ,'001' as ranking_dimen_id                                   --None
    ,'分行' as ranking_dimen_name                                  --None
    ,t1.unit as unit                                             --None
    -- 15
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
INNER JOIN mtl_cmm_intnal_org_info t5 --None 
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
,t5.ORG_ABBR
,t1.unit;
commit;


/*==============第10组==============*/

--临时表01:一级指标-当月-支行
insert into ${idl_schema}.tmp_mc_adac_ind_ranking_dtl_01(
    etl_dt                                                       --ETL处理日期
    ,curr_no                                                     --币种编号
    ,curr_name                                                   --币种名称
    ,index_no                                                    --指标编号
    ,index_name                                                  --指标名称
    -- 5
    ,org_no                                                      --机构编号
    ,org_name                                                    --机构名称
    ,super_org_no                                                --上级机构编号
    ,dimen_obj_id                                                --维度对象编号
    ,dimen_obj_name                                              --维度对象名称
    -- 10
    ,index_value_m                                               --当月指标值
    ,index_value_y                                               --当年指标值
    ,ranking_dimen_id                                            --排行维度编号(001分行002支行团队003客户经理004产品)
    ,ranking_dimen_name                                          --排行维度名称
    ,unit                                                        --单位
    -- 15
)
select
    to_date('${last_month_end}','yyyymmdd') as etl_dt                --None
    ,t2.CURR_CD as curr_no                                       --None
    ,t2.CURR_NAME as curr_name                                   --None
    ,t1.index_no_mcs as index_no                                 --None
    ,t1.index_name_mcs as index_name                             --None
    -- 5
    ,t2.MANAGER_ORG as org_no                                    --None
    ,t2.MANAGER_ORG_NAME as org_name                             --None
    ,substr(t2.MANAGER_ORG,1,3) as super_org_no                  --None
    ,t2.MANAGER_ORG as dimen_obj_id                              --None
    ,t5.ORG_NAME as dimen_obj_name                               --None
    -- 10
    ,case when t1.UNIT ='%'  then nvl(max(t3.kpi_value_m_dk),0)-nvl(max(t4.kpi_value_m_ck),0)
     else SUM(t2.KPI_VALUE_M)
     end as kpi_value_m --当月值
		,case when t1.UNIT ='%'  then nvl(max(t3.kpi_value_y_dk),0)-nvl(max(t4.kpi_value_y_ck),0)
     else SUM(t2.KPI_VALUE_Y)
     end as kpi_value_y --当年值
    ,'002' as ranking_dimen_id                                   --None
    ,'支行团队' as ranking_dimen_name                                --None
    ,t1.unit as unit                                             --None
    -- 15
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
INNER JOIN mtl_cmm_intnal_org_info t5 --None 
 on t5.etl_dt=to_date('${last_month_end}','yyyymmdd')
and t5.ORG_ID=t2.MANAGER_ORG
where t1.source_system='数仓-管会'
and substr(t1.index_no_mcs,length(t1.index_no_mcs)-3,4)='0000' --一级指标
GROUP BY t2.CURR_CD
,t2.CURR_NAME
,t1.index_no_mcs
,t1.index_name_mcs
,t2.MANAGER_ORG
,t2.MANAGER_ORG_NAME
,substr(t2.MANAGER_ORG,1,3)
,t2.MANAGER_ORG
,t5.ORG_NAME
,t1.unit;
commit;


/*==============第11组==============*/

--临时表01:一级指标-当月-客户经理
insert into ${idl_schema}.tmp_mc_adac_ind_ranking_dtl_01(
    etl_dt                                                       --ETL处理日期
    ,curr_no                                                     --币种编号
    ,curr_name                                                   --币种名称
    ,index_no                                                    --指标编号
    ,index_name                                                  --指标名称
    -- 5
    ,org_no                                                      --机构编号
    ,org_name                                                    --机构名称
    ,super_org_no                                                --上级机构编号
    ,dimen_obj_id                                                --维度对象编号
    ,dimen_obj_name                                              --维度对象名称
    -- 10
    ,index_value_m                                               --当月指标值
    ,index_value_y                                               --当年指标值
    ,ranking_dimen_id                                            --排行维度编号(001分行002支行团队003客户经理004产品)
    ,ranking_dimen_name                                          --排行维度名称
    ,unit                                                        --单位
    -- 15
)
select
    to_date('${last_month_end}','yyyymmdd') as etl_dt                --None
    ,t2.CURR_CD as curr_no                                       --None
    ,t2.CURR_NAME as curr_name                                   --None
    ,t1.index_no_mcs as index_no                                 --None
    ,t1.index_name_mcs as index_name                             --None
    -- 5
    ,t2.MANAGER_ORG as org_no                                    --None
    ,t2.MANAGER_ORG_NAME as org_name                             --None
    ,substr(t2.MANAGER_ORG,1,3) as super_org_no                  --None
    ,t2.CUST_MGR_NO as dimen_obj_id                              --None
    ,t2.CUST_MGR_NAME as dimen_obj_name                          --None
    -- 10
    ,case when t1.UNIT ='%'  then nvl(max(t3.kpi_value_m_dk),0)-nvl(max(t4.kpi_value_m_ck),0)
     else SUM(t2.KPI_VALUE_M)
     end as kpi_value_m --当月值
		,case when t1.UNIT ='%'  then nvl(max(t3.kpi_value_y_dk),0)-nvl(max(t4.kpi_value_y_ck),0)
     else SUM(t2.KPI_VALUE_Y)
     end as kpi_value_y --当年值
    ,'003' as ranking_dimen_id                                   --None
    ,'客户经理' as ranking_dimen_name                                --None
    ,t1.unit as unit                                             --None
    -- 15
 from mc_index_define t1 --指标定义表 
INNER JOIN itl_edw_cass_R_RPT_RST0015 t2 --报表-管驾明细表 
 on t2.etl_dt=to_date('${last_month_end}','yyyymmdd')
and t2.index_level1_class = t1.index_clsaa_s_mcs
and t2.CUST_MGR_NO not like 'XN%'
and trim(t2.CUST_MGR_NO) is not null
and t2.CUST_MGR_NO <>'DEF'
left JOIN (select case when SUM(t31.KPI_VALUE_MOM)=0 then 0 else SUM(t31.KPI_VALUE_MM)/SUM(t31.KPI_VALUE_MOM)/extract(day from last_day(to_date('${last_month_end}','yyyymmdd')))*(add_months(trunc(to_date('${last_month_end}','yyyymmdd'),'yyyy'),12)-trunc(to_date('${last_month_end}','yyyymmdd'),'yyyy')) end as kpi_value_m_dk
                 ,case when SUM(t31.KPI_VALUE_YOY)=0 then 0 else SUM(t31.KPI_VALUE_YY)/SUM(t31.KPI_VALUE_YOY)/(to_date('${last_month_end}','yyyymmdd')-decode(substr('${last_month_end}',5,4),'1231',to_date('${last_year_start}','yyyymmdd'),to_date('${year_start}','yyyymmdd'))+1)*(add_months(trunc(to_date('${last_month_end}','yyyymmdd'),'yyyy'),12)-trunc(to_date('${last_month_end}','yyyymmdd'),'yyyy')) end as kpi_value_y_dk
                 ,t31.CURR_CD,t31.CUST_MGR_NO
                from itl_edw_cass_R_RPT_RST0015 t31 --报表-管驾明细表 
               where t31.etl_dt=to_date('${last_month_end}','yyyymmdd')
                and t31.index_level1_class = '存贷利差'            
                and substr(t31.COM_LINE_NAME,length(t31.COM_LINE_NAME)-1)='贷款'
                and t31.CUST_MGR_NO not like 'XN%'
                and trim(t31.CUST_MGR_NO) is not null
				and t31.CUST_MGR_NO <>'DEF'
                and trim(t31.index_level2_class) is null
                group by t31.CURR_CD,t31.CUST_MGR_NO) t3
  on  t3.CURR_CD = t2.CURR_CD
  and t3.CUST_MGR_NO=t2.CUST_MGR_NO
left JOIN (select case when SUM(t41.KPI_VALUE_MOM)=0 then 0 else SUM(t41.KPI_VALUE_MM)/SUM(t41.KPI_VALUE_MOM)/extract(day from last_day(to_date('${last_month_end}','yyyymmdd')))*(add_months(trunc(to_date('${last_month_end}','yyyymmdd'),'yyyy'),12)-trunc(to_date('${last_month_end}','yyyymmdd'),'yyyy')) end as kpi_value_m_ck
                 ,case when SUM(t41.KPI_VALUE_YOY)=0 then 0 else SUM(t41.KPI_VALUE_YY)/SUM(t41.KPI_VALUE_YOY)/(to_date('${last_month_end}','yyyymmdd')-decode(substr('${last_month_end}',5,4),'1231',to_date('${last_year_start}','yyyymmdd'),to_date('${year_start}','yyyymmdd'))+1)*(add_months(trunc(to_date('${last_month_end}','yyyymmdd'),'yyyy'),12)-trunc(to_date('${last_month_end}','yyyymmdd'),'yyyy')) end as kpi_value_y_ck
                 ,t41.CURR_CD,t41.CUST_MGR_NO
                from itl_edw_cass_R_RPT_RST0015 t41 --报表-管驾明细表 
               where t41.etl_dt=to_date('${last_month_end}','yyyymmdd')
                and t41.index_level1_class = '存贷利差'            
                and substr(t41.COM_LINE_NAME,length(t41.COM_LINE_NAME)-1)='存款'
                and t41.CUST_MGR_NO not like 'XN%'
                and trim(t41.CUST_MGR_NO) is not null
				and t41.CUST_MGR_NO <>'DEF'
                and trim(t41.index_level2_class) is null
                group by t41.CURR_CD,t41.CUST_MGR_NO) t4
  on  t4.CURR_CD = t2.CURR_CD
  and t4.CUST_MGR_NO=t2.CUST_MGR_NO
INNER JOIN mtl_cmm_intnal_org_info t5 --None 
 on t5.etl_dt=to_date('${last_month_end}','yyyymmdd')
and t5.ORG_ID=t2.MANAGER_ORG
where t1.source_system='数仓-管会'
and substr(t1.index_no_mcs,length(t1.index_no_mcs)-3,4)='0000' --一级指标
GROUP BY t2.CURR_CD
,t2.CURR_NAME
,t1.index_no_mcs
,t1.index_name_mcs
,substr(t2.MANAGER_ORG,1,3)
,t2.MANAGER_ORG
,t2.MANAGER_ORG_NAME
,t5.ORG_NAME
,t2.CUST_MGR_NO
,t2.CUST_MGR_NAME
,t1.unit;
commit;


/*==============第12.1组==============*/

--临时表01:一级指标-当月-支行-产品
insert into ${idl_schema}.tmp_mc_adac_ind_ranking_dtl_01(
    etl_dt                                                       --ETL处理日期
    ,curr_no                                                     --币种编号
    ,curr_name                                                   --币种名称
    ,index_no                                                    --指标编号
    ,index_name                                                  --指标名称
    -- 5
    ,org_no                                                      --机构编号
    ,org_name                                                    --机构名称
    ,super_org_no                                                --上级机构编号
    ,dimen_obj_id                                                --维度对象编号
    ,dimen_obj_name                                              --维度对象名称
    -- 10
    ,index_value_m                                               --当月指标值
    ,index_value_y                                               --当年指标值
    ,ranking_dimen_id                                            --排行维度编号(001分行002支行团队003客户经理004产品)
    ,ranking_dimen_name                                          --排行维度名称
    ,unit                                                        --单位
    -- 15
)
select
    to_date('${last_month_end}','yyyymmdd') as etl_dt                --None
    ,t2.CURR_CD as curr_no                                       --None
    ,t2.CURR_NAME as curr_name                                   --None
    ,t1.index_no_mcs as index_no                                 --None
    ,t1.index_name_mcs as index_name                             --None
    -- 5
    ,t2.MANAGER_ORG as org_no                                    --None
    ,t2.MANAGER_ORG_NAME as org_name                             --None
    ,substr(t2.MANAGER_ORG,1,3) as super_org_no                  --None
    ,t2.STD_PRO_NO as dimen_obj_id                               --None
    ,t2.STD_PRO_NAME as dimen_obj_name                           --None
    -- 10
    ,case when t1.UNIT ='%'  then nvl(max(t3.kpi_value_m_dk),0)-nvl(max(t4.kpi_value_m_ck),0)
     else SUM(t2.KPI_VALUE_M)
     end as kpi_value_m --当月值
		,case when t1.UNIT ='%'  then nvl(max(t3.kpi_value_y_dk),0)-nvl(max(t4.kpi_value_y_ck),0)
     else SUM(t2.KPI_VALUE_Y)
     end as kpi_value_y --当年值
    ,'004' as ranking_dimen_id                                   --None
    ,'产品' as ranking_dimen_name                                  --None
    ,t1.unit as unit                                             --None
    -- 15
 from mc_index_define t1 --指标定义表 
INNER JOIN itl_edw_cass_R_RPT_RST0015 t2 --报表-管驾明细表 
 on t2.etl_dt=to_date('${last_month_end}','yyyymmdd')
and t2.index_level1_class = t1.index_clsaa_s_mcs
and length(t2.MANAGER_ORG)>3
and t2.MANAGER_ORG<>'000000'
left JOIN (select case when SUM(t31.KPI_VALUE_MOM)=0 then 0 else SUM(t31.KPI_VALUE_MM)/SUM(t31.KPI_VALUE_MOM)/extract(day from last_day(to_date('${last_month_end}','yyyymmdd')))*(add_months(trunc(to_date('${last_month_end}','yyyymmdd'),'yyyy'),12)-trunc(to_date('${last_month_end}','yyyymmdd'),'yyyy')) end as kpi_value_m_dk
                 ,case when SUM(t31.KPI_VALUE_YOY)=0 then 0 else SUM(t31.KPI_VALUE_YY)/SUM(t31.KPI_VALUE_YOY)/(to_date('${last_month_end}','yyyymmdd')-decode(substr('${last_month_end}',5,4),'1231',to_date('${last_year_start}','yyyymmdd'),to_date('${year_start}','yyyymmdd'))+1)*(add_months(trunc(to_date('${last_month_end}','yyyymmdd'),'yyyy'),12)-trunc(to_date('${last_month_end}','yyyymmdd'),'yyyy')) end as kpi_value_y_dk
                 ,t31.CURR_CD,t31.STD_PRO_NO,t31.MANAGER_ORG
                from itl_edw_cass_R_RPT_RST0015 t31 --报表-管驾明细表 
               where t31.etl_dt=to_date('${last_month_end}','yyyymmdd')
                and t31.index_level1_class = '存贷利差'            
                and substr(t31.COM_LINE_NAME,length(t31.COM_LINE_NAME)-1)='贷款'
                and t31.CUST_MGR_NO not like 'XN%'
                and trim(t31.index_level2_class) is null
                group by t31.CURR_CD,t31.STD_PRO_NO,t31.MANAGER_ORG) t3
  on  t3.CURR_CD = t2.CURR_CD
  and t3.STD_PRO_NO=t2.STD_PRO_NO
  and t3.MANAGER_ORG=t2.MANAGER_ORG
left JOIN (select case when SUM(t41.KPI_VALUE_MOM)=0 then 0 else SUM(t41.KPI_VALUE_MM)/SUM(t41.KPI_VALUE_MOM)/extract(day from last_day(to_date('${last_month_end}','yyyymmdd')))*(add_months(trunc(to_date('${last_month_end}','yyyymmdd'),'yyyy'),12)-trunc(to_date('${last_month_end}','yyyymmdd'),'yyyy')) end as kpi_value_m_ck
                 ,case when SUM(t41.KPI_VALUE_YOY)=0 then 0 else SUM(t41.KPI_VALUE_YY)/SUM(t41.KPI_VALUE_YOY)/(to_date('${last_month_end}','yyyymmdd')-decode(substr('${last_month_end}',5,4),'1231',to_date('${last_year_start}','yyyymmdd'),to_date('${year_start}','yyyymmdd'))+1)*(add_months(trunc(to_date('${last_month_end}','yyyymmdd'),'yyyy'),12)-trunc(to_date('${last_month_end}','yyyymmdd'),'yyyy')) end as kpi_value_y_ck
                 ,t41.CURR_CD,t41.STD_PRO_NO,t41.MANAGER_ORG
                from itl_edw_cass_R_RPT_RST0015 t41 --报表-管驾明细表 
               where t41.etl_dt=to_date('${last_month_end}','yyyymmdd')
                and t41.index_level1_class = '存贷利差'            
                and substr(t41.COM_LINE_NAME,length(t41.COM_LINE_NAME)-1)='存款'
                and t41.CUST_MGR_NO not like 'XN%'
                and trim(t41.index_level2_class) is null
                group by t41.CURR_CD,t41.STD_PRO_NO,t41.MANAGER_ORG) t4
  on  t4.CURR_CD = t2.CURR_CD
  and t4.STD_PRO_NO=t2.STD_PRO_NO
  and t4.MANAGER_ORG=t2.MANAGER_ORG
INNER JOIN mtl_cmm_intnal_org_info t5 --None 
 on t5.etl_dt=to_date('${last_month_end}','yyyymmdd')
and t5.ORG_ID=t2.MANAGER_ORG
where t1.source_system='数仓-管会'
and substr(t1.index_no_mcs,length(t1.index_no_mcs)-3,4)='0000' --一级指标
GROUP BY t2.CURR_CD
,t2.CURR_NAME
,t1.index_no_mcs
,t1.index_name_mcs
,substr(t2.MANAGER_ORG,1,3)
,t2.MANAGER_ORG
,t2.MANAGER_ORG_NAME
,t5.ORG_NAME
,t2.STD_PRO_NO
,t2.STD_PRO_NAME
,t1.unit;
commit;

/*==============第12.2组==============*/

--临时表01:一级指标-当月-分行-产品
insert into ${idl_schema}.tmp_mc_adac_ind_ranking_dtl_01(
    etl_dt                                                       --ETL处理日期
    ,curr_no                                                     --币种编号
    ,curr_name                                                   --币种名称
    ,index_no                                                    --指标编号
    ,index_name                                                  --指标名称
    -- 5
    ,org_no                                                      --机构编号
    ,org_name                                                    --机构名称
    ,super_org_no                                                --上级机构编号
    ,dimen_obj_id                                                --维度对象编号
    ,dimen_obj_name                                              --维度对象名称
    -- 10
    ,index_value_m                                               --当月指标值
    ,index_value_y                                               --当年指标值
    ,ranking_dimen_id                                            --排行维度编号(001分行002支行团队003客户经理004产品)
    ,ranking_dimen_name                                          --排行维度名称
    ,unit                                                        --单位
    -- 15
)
select
    to_date('${last_month_end}','yyyymmdd') as etl_dt                --None
    ,t2.CURR_CD as curr_no                                       --None
    ,t2.CURR_NAME as curr_name                                   --None
    ,t1.index_no_mcs as index_no                                 --None
    ,t1.index_name_mcs as index_name                             --None
    -- 5
    ,substr(t2.MANAGER_ORG,1,3) as org_no                                    --None
    ,t5.ORG_NAME as org_name                             --None
    ,'000000' as super_org_no                  --None
    ,t2.STD_PRO_NO as dimen_obj_id                               --None
    ,t2.STD_PRO_NAME as dimen_obj_name                           --None
    -- 10
    ,case when t1.UNIT ='%'  then nvl(max(t3.kpi_value_m_dk),0)-nvl(max(t4.kpi_value_m_ck),0)
     else SUM(t2.KPI_VALUE_M)
     end as kpi_value_m --当月值
		,case when t1.UNIT ='%'  then nvl(max(t3.kpi_value_y_dk),0)-nvl(max(t4.kpi_value_y_ck),0)
     else SUM(t2.KPI_VALUE_Y)
     end as kpi_value_y --当年值
    ,'004' as ranking_dimen_id                                   --None
    ,'产品' as ranking_dimen_name                                  --None
    ,t1.unit as unit                                             --None
    -- 15
 from mc_index_define t1 --指标定义表 
INNER JOIN itl_edw_cass_R_RPT_RST0015 t2 --报表-管驾明细表 
 on t2.etl_dt=to_date('${last_month_end}','yyyymmdd')
and t2.index_level1_class = t1.index_clsaa_s_mcs
left JOIN (select case when SUM(t31.KPI_VALUE_MOM)=0 then 0 else SUM(t31.KPI_VALUE_MM)/SUM(t31.KPI_VALUE_MOM)/extract(day from last_day(to_date('${last_month_end}','yyyymmdd')))*(add_months(trunc(to_date('${last_month_end}','yyyymmdd'),'yyyy'),12)-trunc(to_date('${last_month_end}','yyyymmdd'),'yyyy')) end as kpi_value_m_dk
                 ,case when SUM(t31.KPI_VALUE_YOY)=0 then 0 else SUM(t31.KPI_VALUE_YY)/SUM(t31.KPI_VALUE_YOY)/(to_date('${last_month_end}','yyyymmdd')-decode(substr('${last_month_end}',5,4),'1231',to_date('${last_year_start}','yyyymmdd'),to_date('${year_start}','yyyymmdd'))+1)*(add_months(trunc(to_date('${last_month_end}','yyyymmdd'),'yyyy'),12)-trunc(to_date('${last_month_end}','yyyymmdd'),'yyyy')) end as kpi_value_y_dk
                 ,t31.CURR_CD,t31.STD_PRO_NO,substr(t31.MANAGER_ORG,1,3) as MANAGER_ORG
                from itl_edw_cass_R_RPT_RST0015 t31 --报表-管驾明细表 
               where t31.etl_dt=to_date('${last_month_end}','yyyymmdd')
                and t31.index_level1_class = '存贷利差'            
                and substr(t31.COM_LINE_NAME,length(t31.COM_LINE_NAME)-1)='贷款'
                and t31.CUST_MGR_NO not like 'XN%'
                and trim(t31.index_level2_class) is null
                group by t31.CURR_CD,t31.STD_PRO_NO,substr(t31.MANAGER_ORG,1,3)) t3
  on  t3.CURR_CD = t2.CURR_CD
  and t3.STD_PRO_NO=t2.STD_PRO_NO
  and t3.MANAGER_ORG=substr(t2.MANAGER_ORG,1,3)
left JOIN (select case when SUM(t41.KPI_VALUE_MOM)=0 then 0 else SUM(t41.KPI_VALUE_MM)/SUM(t41.KPI_VALUE_MOM)/extract(day from last_day(to_date('${last_month_end}','yyyymmdd')))*(add_months(trunc(to_date('${last_month_end}','yyyymmdd'),'yyyy'),12)-trunc(to_date('${last_month_end}','yyyymmdd'),'yyyy')) end as kpi_value_m_ck
                 ,case when SUM(t41.KPI_VALUE_YOY)=0 then 0 else SUM(t41.KPI_VALUE_YY)/SUM(t41.KPI_VALUE_YOY)/(to_date('${last_month_end}','yyyymmdd')-decode(substr('${last_month_end}',5,4),'1231',to_date('${last_year_start}','yyyymmdd'),to_date('${year_start}','yyyymmdd'))+1)*(add_months(trunc(to_date('${last_month_end}','yyyymmdd'),'yyyy'),12)-trunc(to_date('${last_month_end}','yyyymmdd'),'yyyy')) end as kpi_value_y_ck
                 ,t41.CURR_CD,t41.STD_PRO_NO,substr(t41.MANAGER_ORG,1,3) as MANAGER_ORG
                from itl_edw_cass_R_RPT_RST0015 t41 --报表-管驾明细表 
               where t41.etl_dt=to_date('${last_month_end}','yyyymmdd')
                and t41.index_level1_class = '存贷利差'            
                and substr(t41.COM_LINE_NAME,length(t41.COM_LINE_NAME)-1)='存款'
                and t41.CUST_MGR_NO not like 'XN%'
                and trim(t41.index_level2_class) is null
                group by t41.CURR_CD,t41.STD_PRO_NO,substr(t41.MANAGER_ORG,1,3)) t4
  on  t4.CURR_CD = t2.CURR_CD
  and t4.STD_PRO_NO=t2.STD_PRO_NO
  and t4.MANAGER_ORG=substr(t2.MANAGER_ORG,1,3)
INNER JOIN mtl_cmm_intnal_org_info t5 --None 
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
,t2.STD_PRO_NO
,t2.STD_PRO_NAME
,t1.unit;
commit;

/*==============第12.3组==============*/

--临时表01:一级指标-当月-全行-产品
insert into ${idl_schema}.tmp_mc_adac_ind_ranking_dtl_01(
    etl_dt                                                       --ETL处理日期
    ,curr_no                                                     --币种编号
    ,curr_name                                                   --币种名称
    ,index_no                                                    --指标编号
    ,index_name                                                  --指标名称
    -- 5
    ,org_no                                                      --机构编号
    ,org_name                                                    --机构名称
    ,super_org_no                                                --上级机构编号
    ,dimen_obj_id                                                --维度对象编号
    ,dimen_obj_name                                              --维度对象名称
    -- 10
    ,index_value_m                                               --当月指标值
    ,index_value_y                                               --当年指标值
    ,ranking_dimen_id                                            --排行维度编号(001分行002支行团队003客户经理004产品)
    ,ranking_dimen_name                                          --排行维度名称
    ,unit                                                        --单位
    -- 15
)
select
    to_date('${last_month_end}','yyyymmdd') as etl_dt                --None
    ,t2.CURR_CD as curr_no                                       --None
    ,t2.CURR_NAME as curr_name                                   --None
    ,t1.index_no_mcs as index_no                                 --None
    ,t1.index_name_mcs as index_name                             --None
    -- 5
    ,'000000' as org_no                                    --None
    ,'全行' as org_name                             --None
    ,'999999' as super_org_no                  --None
    ,t2.STD_PRO_NO as dimen_obj_id                               --None
    ,t2.STD_PRO_NAME as dimen_obj_name                           --None
    -- 10
    ,case when t1.UNIT ='%'  then nvl(sum(t3.kpi_value_m_dk),0)-nvl(sum(t4.kpi_value_m_ck),0)
     else SUM(t2.KPI_VALUE_M)
     end as kpi_value_m --当月值
		,case when t1.UNIT ='%'  then nvl(sum(t3.kpi_value_y_dk),0)-nvl(sum(t4.kpi_value_y_ck),0)
     else SUM(t2.KPI_VALUE_Y)
     end as kpi_value_y --当年值
    ,'004' as ranking_dimen_id                                   --None
    ,'产品' as ranking_dimen_name                                  --None
    ,t1.unit as unit                                             --None
    -- 15
 from mc_index_define t1 --指标定义表 
INNER JOIN itl_edw_cass_R_RPT_RST0015 t2 --报表-管驾明细表 
 on t2.etl_dt=to_date('${last_month_end}','yyyymmdd')
and t2.index_level1_class = t1.index_clsaa_s_mcs
left JOIN (select case when SUM(t31.KPI_VALUE_MOM)=0 then 0 else SUM(t31.KPI_VALUE_MM)/SUM(t31.KPI_VALUE_MOM)/extract(day from last_day(to_date('${last_month_end}','yyyymmdd')))*(add_months(trunc(to_date('${last_month_end}','yyyymmdd'),'yyyy'),12)-trunc(to_date('${last_month_end}','yyyymmdd'),'yyyy')) end as kpi_value_m_dk
                 ,case when SUM(t31.KPI_VALUE_YOY)=0 then 0 else SUM(t31.KPI_VALUE_YY)/SUM(t31.KPI_VALUE_YOY)/(to_date('${last_month_end}','yyyymmdd')-decode(substr('${last_month_end}',5,4),'1231',to_date('${last_year_start}','yyyymmdd'),to_date('${year_start}','yyyymmdd'))+1)*(add_months(trunc(to_date('${last_month_end}','yyyymmdd'),'yyyy'),12)-trunc(to_date('${last_month_end}','yyyymmdd'),'yyyy')) end as kpi_value_y_dk
                 ,t31.CURR_CD,t31.STD_PRO_NO
                from itl_edw_cass_R_RPT_RST0015 t31 --报表-管驾明细表 
               where t31.etl_dt=to_date('${last_month_end}','yyyymmdd')
                and t31.index_level1_class = '存贷利差'            
                and substr(t31.COM_LINE_NAME,length(t31.COM_LINE_NAME)-1)='贷款'
                and t31.CUST_MGR_NO not like 'XN%'
                and trim(t31.index_level2_class) is null
                group by t31.CURR_CD,t31.STD_PRO_NO) t3
  on  t3.CURR_CD = t2.CURR_CD
  and t3.STD_PRO_NO=t2.STD_PRO_NO
left JOIN (select case when SUM(t41.KPI_VALUE_MOM)=0 then 0 else SUM(t41.KPI_VALUE_MM)/SUM(t41.KPI_VALUE_MOM)/extract(day from last_day(to_date('${last_month_end}','yyyymmdd')))*(add_months(trunc(to_date('${last_month_end}','yyyymmdd'),'yyyy'),12)-trunc(to_date('${last_month_end}','yyyymmdd'),'yyyy')) end as kpi_value_m_ck
                 ,case when SUM(t41.KPI_VALUE_YOY)=0 then 0 else SUM(t41.KPI_VALUE_YY)/SUM(t41.KPI_VALUE_YOY)/(to_date('${last_month_end}','yyyymmdd')-decode(substr('${last_month_end}',5,4),'1231',to_date('${last_year_start}','yyyymmdd'),to_date('${year_start}','yyyymmdd'))+1)*(add_months(trunc(to_date('${last_month_end}','yyyymmdd'),'yyyy'),12)-trunc(to_date('${last_month_end}','yyyymmdd'),'yyyy')) end as kpi_value_y_ck
                 ,t41.CURR_CD,t41.STD_PRO_NO
                from itl_edw_cass_R_RPT_RST0015 t41 --报表-管驾明细表 
               where t41.etl_dt=to_date('${last_month_end}','yyyymmdd')
                and t41.index_level1_class = '存贷利差'            
                and substr(t41.COM_LINE_NAME,length(t41.COM_LINE_NAME)-1)='存款'
                and t41.CUST_MGR_NO not like 'XN%'
                and trim(t41.index_level2_class) is null
                group by t41.CURR_CD,t41.STD_PRO_NO) t4
  on  t4.CURR_CD = t2.CURR_CD
  and t4.STD_PRO_NO=t2.STD_PRO_NO
where t1.source_system='数仓-管会'
and substr(t1.index_no_mcs,length(t1.index_no_mcs)-3,4)='0000' --一级指标
GROUP BY t2.CURR_CD
,t2.CURR_NAME
,t1.index_no_mcs
,t1.index_name_mcs
,t2.STD_PRO_NO
,t2.STD_PRO_NAME
,t1.unit;
commit;

/*==============第13组==============*/

--插入目标表:当月值
insert into ${idl_schema}.mc_adac_ind_ranking_dtl(
    etl_dt                                                       --ETL处理日期
    ,curr_no                                                     --币种编号
    ,curr_name                                                   --币种名称
    ,index_no                                                    --指标编号
    ,index_name                                                  --指标名称
    -- 5
    ,org_no                                                      --机构编号
    ,org_name                                                    --机构名称
    ,super_org_no                                                --上级机构编号
    ,dimen_obj_id                                                --维度对象编号
    ,dimen_obj_name                                              --维度对象名称
    -- 10
    ,measure_no                                                  --度量编号
    ,index_measure                                               --度量名称
    ,index_value                                                 --指标值
    ,rate_up_day                                                 --较上日
    ,rate_up_day_per                                             --较上日百分比
    -- 15
    ,rate_last_month                                             --较上月
    ,rate_last_month_per                                         --较上月百分比
    ,rate_last_year                                              --较上年
    ,rate_last_year_per                                          --较上年百分比
    ,rate_last_period                                            --较上年同期
    -- 20
    ,rate_last_period_per                                        --较上年同期百分比
    ,index_ranking                                               --排名
    ,ratio_index                                                 --占比
    ,ranking_dimen_id                                            --排行维度编号(001分行002支行团队003客户经理004产品)
    ,ranking_dimen_name                                          --排行维度名称
    -- 25
    ,unit                                                        --单位
    ,etl_timestamp                                               --ETL处理时间戳
)
select
    to_date('${last_month_end}','yyyymmdd') as etl_dt                --None
    ,t1.CURR_NO as curr_no                                       --None
    ,t1.CURR_NAME as curr_name                                   --None
    ,t1.INDEX_NO as index_no                                     --None
    ,t1.INDEX_NAME as index_name                                 --None
    -- 5
    ,t1.ORG_NO as org_no                                         --None
    ,t1.ORG_NAME as org_name                                     --None
    ,t1.SUPER_ORG_NO as super_org_no                             --None
    ,t1.DIMEN_OBJ_ID as dimen_obj_id                             --None
    ,t1.DIMEN_OBJ_NAME as dimen_obj_name                         --None
    -- 10
    ,'002' as measure_no                                         --None
    ,'当月值' as index_measure                                      --None
    ,t1.INDEX_VALUE_M as index_value                             --None
    ,0 as rate_up_day                                            --None
    ,0 as rate_up_day_per                                        --None
    -- 15
    ,coalesce(t1.INDEX_VALUE_M,0) - coalesce(t3.INDEX_VALUE,0) as rate_last_month --较上月
    ,case when coalesce(t3.INDEX_VALUE ,0) =0 then 0 
               else  round((coalesce(t1.INDEX_VALUE_M,0) - coalesce(t3.INDEX_VALUE,0)) / coalesce(t3.INDEX_VALUE,0),6) 
               end as rate_last_month_per --较上月百分比
    ,coalesce(t1.INDEX_VALUE_M,0) - coalesce(t2.INDEX_VALUE,0) as rate_last_year --较上年
    ,case when coalesce(t2.INDEX_VALUE ,0) =0 then 0 
               else  round((coalesce(t1.INDEX_VALUE_M,0) - coalesce(t2.INDEX_VALUE,0)) / coalesce(t2.INDEX_VALUE,0),6) 
               end as rate_last_year_per --较上年百分比
    ,coalesce(t1.INDEX_VALUE_M,0) - coalesce(t4.INDEX_VALUE,0) as rate_last_period --较上年同期
    -- 20
    ,case when coalesce(t4.INDEX_VALUE ,0) =0 then 0 
               else  round((coalesce(t1.INDEX_VALUE_M,0) - coalesce(t4.INDEX_VALUE,0)) / coalesce(t4.INDEX_VALUE,0),6) 
               end as rate_last_period_per --较上年同期百分比
    ,null as index_ranking                                       --None
    ,null as ratio_index                                         --None
    ,t1.RANKING_DIMEN_ID as ranking_dimen_id                     --None
    ,t1.RANKING_DIMEN_NAME as ranking_dimen_name                 --None
    -- 25
    ,t1.UNIT as unit                                             --None
    ,TO_TIMESTAMP('${batch_timestamp}','yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp --None
 from tmp_mc_adac_ind_ranking_dtl_01 t1 --None 
LEFT JOIN mc_adac_ind_ranking_dtl t2 --None 
 on t2.etl_dt=decode(substr('${last_month_end}',5,4),'1231',trunc(to_date('${last_month_end}','yyyymmdd'),'yy') -1 ,to_date('${last_year_end}','yyyymmdd'))
and t2.curr_no=t1.curr_no
and t2.index_no=t1.index_no
and t2.org_no=t1.ORG_NO
and t2.dimen_obj_id=t1.dimen_obj_id
and t2.ranking_dimen_id=t1.ranking_dimen_id
and t2.MEASURE_NO='002'
LEFT JOIN mc_adac_ind_ranking_dtl t3 --None 
 on t3.etl_dt=to_date('${previous_month_end}','yyyymmdd')
and t3.curr_no=t1.curr_no
and t3.index_no=t1.index_no
and t3.org_no=t1.ORG_NO
and t3.dimen_obj_id=t1.dimen_obj_id
and t3.ranking_dimen_id=t1.ranking_dimen_id
and t3.MEASURE_NO='002'
LEFT JOIN mc_adac_ind_ranking_dtl t4 --None 
 on t4.etl_dt=add_months(to_date('${last_month_end}','yyyymmdd'), -12)
and t4.curr_no=t1.curr_no
and t4.index_no=t1.index_no
and t4.org_no=t1.ORG_NO
and t4.dimen_obj_id=t1.dimen_obj_id
and t4.ranking_dimen_id=t1.ranking_dimen_id
and t4.MEASURE_NO='002'
LEFT JOIN mtl_cmm_intnal_org_info t5 --None 
 on t5.etl_dt=to_date('${last_month_end}','yyyymmdd')
and t5.org_id=t1.org_no
where (case when t1.RANKING_DIMEN_ID='001' 
    and t5.org_lev_cd = '02'
    and t5.org_type_cd = '11'
    AND t5.org_status_cd = '2' --已启用
    AND t5.bus_status_cd = '2' --正常营业
    AND t5.org_id NOT LIKE '89%' -- 排除事业部
    and t5.admin_super_org_id = '000000' then 'true' --分行维度只展示11家分行
	when t1.RANKING_DIMEN_ID in ('002','003')
	and t5.org_status_cd = '2'
    and t5.admin_super_org_id in (
        '801',
        '802',
        '803',
        '805',
        '806',
        '807',
        '808',
        '809',
        '810',
        '811',
        '812') then 'true'--支行维度只展示所有的支行加团队,不要加总分行职能部门 
	when t1.RANKING_DIMEN_ID not in ('003','002','001') then 'true'
    else 'false' end)='true'
 
 
;
commit;


/*==============第14组==============*/

--插入目标表:当年值
insert into ${idl_schema}.mc_adac_ind_ranking_dtl(
    etl_dt                                                       --ETL处理日期
    ,curr_no                                                     --币种编号
    ,curr_name                                                   --币种名称
    ,index_no                                                    --指标编号
    ,index_name                                                  --指标名称
    -- 5
    ,org_no                                                      --机构编号
    ,org_name                                                    --机构名称
    ,super_org_no                                                --上级机构编号
    ,dimen_obj_id                                                --维度对象编号
    ,dimen_obj_name                                              --维度对象名称
    -- 10
    ,measure_no                                                  --度量编号
    ,index_measure                                               --度量名称
    ,index_value                                                 --指标值
    ,rate_up_day                                                 --较上日
    ,rate_up_day_per                                             --较上日百分比
    -- 15
    ,rate_last_month                                             --较上月
    ,rate_last_month_per                                         --较上月百分比
    ,rate_last_year                                              --较上年
    ,rate_last_year_per                                          --较上年百分比
    ,rate_last_period                                            --较上年同期
    -- 20
    ,rate_last_period_per                                        --较上年同期百分比
    ,index_ranking                                               --排名
    ,ratio_index                                                 --占比
    ,ranking_dimen_id                                            --排行维度编号(001分行002支行团队003客户经理004产品)
    ,ranking_dimen_name                                          --排行维度名称
    -- 25
    ,unit                                                        --单位
    ,etl_timestamp                                               --ETL处理时间戳
)
select
    to_date('${last_month_end}','yyyymmdd') as etl_dt                --None
    ,t1.CURR_NO as curr_no                                       --None
    ,t1.CURR_NAME as curr_name                                   --None
    ,t1.INDEX_NO as index_no                                     --None
    ,t1.INDEX_NAME as index_name                                 --None
    -- 5
    ,t1.ORG_NO as org_no                                         --None
    ,t1.ORG_NAME as org_name                                     --None
    ,t1.SUPER_ORG_NO as super_org_no                             --None
    ,t1.DIMEN_OBJ_ID as dimen_obj_id                             --None
    ,t1.DIMEN_OBJ_NAME as dimen_obj_name                         --None
    -- 10
    ,'004' as measure_no                                         --None
    ,'当年值' as index_measure                                      --None
    ,t1.INDEX_VALUE_Y as index_value                             --None
    ,0 as rate_up_day                                            --None
    ,0 as rate_up_day_per                                        --None
    -- 15
    ,coalesce(t1.INDEX_VALUE_Y,0) - coalesce(t3.INDEX_VALUE,0) as rate_last_month --较上月
    ,case when coalesce(t3.INDEX_VALUE ,0) =0 then 0 
               else  round((coalesce(t1.INDEX_VALUE_Y,0) - coalesce(t3.INDEX_VALUE,0)) / coalesce(t3.INDEX_VALUE,0),6) 
               end as rate_last_month_per --较上月百分比
    ,coalesce(t1.INDEX_VALUE_Y,0) - coalesce(t2.INDEX_VALUE,0) as rate_last_year --较上年
    ,case when coalesce(t2.INDEX_VALUE ,0) =0 then 0 
               else  round((coalesce(t1.INDEX_VALUE_Y,0) - coalesce(t2.INDEX_VALUE,0)) / coalesce(t2.INDEX_VALUE,0),6) 
               end as rate_last_year_per --较上年百分比
    ,coalesce(t1.INDEX_VALUE_Y,0) - coalesce(t4.INDEX_VALUE,0) as rate_last_period --较上年同期
    -- 20
    ,case when coalesce(t4.INDEX_VALUE ,0) =0 then 0 
               else  round((coalesce(t1.INDEX_VALUE_Y,0) - coalesce(t4.INDEX_VALUE,0)) / coalesce(t4.INDEX_VALUE,0),6) 
               end as rate_last_period_per --较上年同期百分比
    ,null as index_ranking                                       --None
    ,null as ratio_index                                         --None
    ,t1.RANKING_DIMEN_ID as ranking_dimen_id                     --None
    ,t1.RANKING_DIMEN_NAME as ranking_dimen_name                 --None
    -- 25
    ,t1.UNIT as unit                                             --None
    ,TO_TIMESTAMP('${batch_timestamp}','yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp --None
 from tmp_mc_adac_ind_ranking_dtl_01 t1 --None 
LEFT JOIN mc_adac_ind_ranking_dtl t2 --None 
 on t2.etl_dt=decode(substr('${last_month_end}',5,4),'1231',trunc(to_date('${last_month_end}','yyyymmdd'),'yy') -1 ,to_date('${last_year_end}','yyyymmdd'))
and t2.curr_no=t1.curr_no
and t2.index_no=t1.index_no
and t2.org_no=t1.ORG_NO
and t2.dimen_obj_id=t1.dimen_obj_id
and t2.ranking_dimen_id=t1.ranking_dimen_id
and t2.MEASURE_NO='004'
LEFT JOIN mc_adac_ind_ranking_dtl t3 --None 
 on t3.etl_dt=to_date('${previous_month_end}','yyyymmdd')
and t3.curr_no=t1.curr_no
and t3.index_no=t1.index_no
and t3.org_no=t1.ORG_NO
and t3.dimen_obj_id=t1.dimen_obj_id
and t3.ranking_dimen_id=t1.ranking_dimen_id
and t3.MEASURE_NO='004'
LEFT JOIN mc_adac_ind_ranking_dtl t4 --None 
 on t4.etl_dt=add_months(to_date('${last_month_end}','yyyymmdd'), -12)
and t4.curr_no=t1.curr_no
and t4.index_no=t1.index_no
and t4.org_no=t1.ORG_NO
and t4.dimen_obj_id=t1.dimen_obj_id
and t4.ranking_dimen_id=t1.ranking_dimen_id
and t4.MEASURE_NO='004'
LEFT JOIN mtl_cmm_intnal_org_info t5 --None 
 on t5.etl_dt=to_date('${last_month_end}','yyyymmdd')
and t5.org_id=t1.org_no
where (case when t1.RANKING_DIMEN_ID='001' 
    and t5.org_lev_cd = '02'
    and t5.org_type_cd = '11'
    AND t5.org_status_cd = '2' --已启用
    AND t5.bus_status_cd = '2' --正常营业
    AND t5.org_id NOT LIKE '89%' -- 排除事业部
    and t5.admin_super_org_id = '000000' then 'true' --分行维度只展示11家分行
	when t1.RANKING_DIMEN_ID in ('002','003') 
	and t5.org_status_cd = '2'
    and t5.admin_super_org_id in (
        '801',
        '802',
        '803',
        '805',
        '806',
        '807',
        '808',
        '809',
        '810',
        '811',
        '812') then 'true'--支行维度只展示所有的支行加团队,不要加总分行职能部门 
	when t1.RANKING_DIMEN_ID not in ('003','002','001') then 'true'
    else 'false' end)='true'
 
 
;
commit;

--delete tmp table
whenever sqlerror continue none;
drop table ${idl_schema}.tmp_mc_adac_ind_ranking_dtl_01 purge;

-- 3.1 gather table status
exec dbms_stats.gather_table_stats(ownname => '${idl_schema}',tabname => 'mc_adac_ind_ranking_dtl',partname => 'p_${last_month_end}', granularity => 'PARTITION', degree => 8, cascade => true);
