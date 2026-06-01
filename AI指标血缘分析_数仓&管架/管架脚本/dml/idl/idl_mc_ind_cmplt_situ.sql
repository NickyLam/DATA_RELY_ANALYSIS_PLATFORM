/*
Purpose:    IDL-指标完成情况
Creater:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd idl_mc_ind_cmplt_situ
CreateDate: None
FileType:   DML
Logs:
    表英文名： mc_ind_cmplt_situ
    表中文名： 指标完成情况
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
        2025-12-15    郑沛隆    新建脚本    
        2026-03-18    蔡如锋    修改脚本逻辑及新增字段    
        2026-03-23    郑沛隆    将补录数据后补到正常出数逻辑中进行互补    
*/


--设置参数
set timing on
-- 0.1 alter parallel
alter session force parallel query parallel 8;
alter session force parallel dml parallel 8;
-- 1.1 create table for exchage
whenever sqlerror continue none;
alter table ${idl_schema}.mc_ind_cmplt_situ add partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));
alter table ${idl_schema}.mc_ind_cmplt_situ truncate partition p_${batch_date};

whenever sqlerror exit sql.sqlcode; 

/*==============第1组==============*/

--临时表01:主要经营指标完成情况-补录
whenever sqlerror continue none;
drop table ${idl_schema}.tmp_mc_ind_cmplt_situ_01 purge;
whenever sqlerror exit sql.sqlcode;
create table ${idl_schema}.tmp_mc_ind_cmplt_situ_01 (
    index_no varchar2(150)                                        --指标编号
    ,index_name varchar2(200) --指标名称
    ,org_no varchar2(150) --机构编号
    ,org_name varchar2(200) --机构名称
    ,measure_no varchar2(150) --度量编号
    -- 5
    ,index_value number(38,8) --指标值
    ,index_value_desc varchar2(200) --指标值备注
    ,budget_val varchar2(200) --预算值
    ,budget_val_desc varchar2(200) --预算值备注
    ,prog_target_val number(38,8) --进度目标值
    -- 10
    ,tm_prog_cmplt_rat number(38,8) --时间进度完成率
    ,tm_prog_cmplt_rat_desc varchar2(200) --时间进度完成率备注
    ,year_cmplt_rat number(38,8) --年度完成率
    ,year_cmplt_rat_desc varchar2(200) --年度完成率备注
    ,unit varchar2(150) --指标单位
    -- 15
    ,reach_std_situ varchar2(150) --达标情况
    ,ind_net_incre number(38,8) --指标净增值
    ,last_year_base number(38,8) --上年基数
    ,m_acm_val number(38,8) --月累计值
    ,yoy_val number(38,8) --同比值
    -- 20
    ,yoy_chg_lmt number(38,8) --同比变动额
    ,yoy_chg_rat number(38,8) --同比变动率
    ,chain_val number(38,8) --环比值
    ,chain_chg_lmt number(38,8) --环比变动额
    ,chain_chg_rat number(38,8) --环比变动率
    -- 25
    ,etl_dt date --ETL处理日期
    ,etl_timestamp timestamp(6) --ETL处理时间戳
)
 ;

insert into ${idl_schema}.tmp_mc_ind_cmplt_situ_01(
    index_no                                                     --指标编号
    ,index_name                                                  --指标名称
    ,org_no                                                      --机构编号
    ,org_name                                                    --机构名称
    ,measure_no                                                  --度量编号
    -- 5
    ,index_value                                                 --指标值
    ,index_value_desc                                            --指标值备注
    ,budget_val                                                  --预算值
    ,budget_val_desc                                             --预算值备注
    ,prog_target_val                                             --进度目标值
    -- 10
    ,tm_prog_cmplt_rat                                           --时间进度完成率
    ,tm_prog_cmplt_rat_desc                                      --时间进度完成率备注
    ,year_cmplt_rat                                              --年度完成率
    ,year_cmplt_rat_desc                                         --年度完成率备注
    ,unit                                                        --指标单位
    -- 15
    ,reach_std_situ                                              --达标情况
    ,ind_net_incre                                               --指标净增值
    ,last_year_base                                              --上年基数
    ,m_acm_val                                                   --月累计值
    ,yoy_val                                                     --同比值
    -- 20
    ,yoy_chg_lmt                                                 --同比变动额
    ,yoy_chg_rat                                                 --同比变动率
    ,chain_val                                                   --环比值
    ,chain_chg_lmt                                               --环比变动额
    ,chain_chg_rat                                               --环比变动率
    -- 25
    ,etl_dt                                                      --ETL处理日期
    ,etl_timestamp                                               --ETL处理时间戳
)
select
    t3.INDEX_NO_MCS as index_no                                  --管驾指标编号
    ,t3.INDEX_NAME_MCS as index_name                             --管驾指标名称
    ,t1.ORG_NO as org_no                                         --机构编号
    ,t4.ORG_NAME as org_name                                     --机构名称
    ,'001' as measure_no                                         --None
    -- 5
    ,case when t3.UNIT='亿元' then t1.INDEX_VALUE*100000000 
     when t3.UNIT='万元' then t1.INDEX_VALUE*10000
else t1.INDEX_VALUE end as index_value --None
    ,'' as index_value_desc                                      --None
    ,case when t3.UNIT='亿元' then to_char(t1.BUDGET_VAL*100000000)
     when t3.UNIT='万元' then to_char(t1.BUDGET_VAL*10000)
else t1.BUDGET_VAL end as budget_val --None
    ,'' as budget_val_desc                                       --None
    ,case when t3.UNIT<>'%' then t1.BUDGET_VAL/12*(extract (month from t1.etl_dt))end as prog_target_val --None
    -- 10
    ,case when t3.UNIT<>'%' then t1.index_value/(t1.BUDGET_VAL/12*(extract (month from t1.etl_dt)))end as tm_prog_cmplt_rat --None
    ,'' as tm_prog_cmplt_rat_desc                                --None
    ,case when t3.UNIT<>'%' then t1.index_value/t1.BUDGET_VAL end as year_cmplt_rat --None
    ,'' as year_cmplt_rat_desc                                   --None
    ,t3.UNIT as unit                                             --指标单位
    -- 15
    ,case when t3.UNIT<>'%' then ''
     when t3.UNIT='%' then '达标'
end as reach_std_situ --None
    ,NULL as ind_net_incre                                       --None
    ,NULL as last_year_base                                      --None
    ,NULL as m_acm_val                                           --None
    ,NULL as yoy_val                                             --None
    -- 20
    ,NULL as yoy_chg_lmt                                         --None
    ,NULL as yoy_chg_rat                                         --None
    ,NULL as chain_val                                           --None
    ,NULL as chain_chg_lmt                                       --None
    ,NULL as chain_chg_rat                                       --None
    -- 25
    ,to_date('${batch_date}','yyyymmdd') as etl_dt               --None
    ,TO_TIMESTAMP('${batch_timestamp}','yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp --None
 from mc_ind_cmplt_situ_bl t1 --指标完成情况补录表 
LEFT JOIN mc_ind_cmplt_situ t2 --指标完成情况 
 on t1.index_no=t2.index_no
and t1.org_no=t2.org_no
and t2.etl_dt=to_date('${last_month_end}','yyyymmdd')
INNER JOIN mc_asses_index_define t3 --考核模块指标定义表 
 on t1.index_no=t3.index_no_mcs
and t3.index_state='在用'
and t3.module_name='全行主要经营指标完成情况'
and t3.etl_dt=to_date('${batch_date}','yyyymmdd')
LEFT JOIN mc_orga_para_jxkh t4 --绩效考核机构表 
 on t1.org_no=t4.org_no
where t1.etl_dt=to_date('${batch_date}','yyyymmdd')
 ;
commit;


/*==============第2组==============*/

--临时表01:条线FTP营收及主要指标完成情况-补录
insert into ${idl_schema}.tmp_mc_ind_cmplt_situ_01(
    index_no                                                     --指标编号
    ,index_name                                                  --指标名称
    ,org_no                                                      --机构编号
    ,org_name                                                    --机构名称
    ,measure_no                                                  --度量编号
    -- 5
    ,index_value                                                 --指标值
    ,budget_val                                                  --预算值
    ,prog_target_val                                             --进度目标值
    ,tm_prog_cmplt_rat                                           --时间进度完成率
    ,year_cmplt_rat                                              --年度完成率
    -- 10
    ,unit                                                        --指标单位
    ,ind_net_incre                                               --指标净增值
    ,last_year_base                                              --上年基数
    ,m_acm_val                                                   --月累计值
    ,yoy_val                                                     --同比值
    -- 15
    ,yoy_chg_lmt                                                 --同比变动额
    ,yoy_chg_rat                                                 --同比变动率
    ,chain_val                                                   --环比值
    ,chain_chg_lmt                                               --环比变动额
    ,chain_chg_rat                                               --环比变动率
    -- 20
    ,etl_dt                                                      --ETL处理日期
    ,etl_timestamp                                               --ETL处理时间戳
)
select
    t3.INDEX_NO_MCS as index_no                                  --管驾指标编号
    ,t3.INDEX_NAME_MCS as index_name                             --管驾指标名称
    ,t1.ORG_NO as org_no                                         --机构编号
    ,t4.ORG_NAME as org_name                                     --机构名称
    ,'001' as measure_no                                         --None
    -- 5
    ,case when t3.UNIT='亿元' then t1.INDEX_VALUE*100000000 
     when t3.UNIT='万元' then t1.INDEX_VALUE*10000
else t1.INDEX_VALUE end as index_value --None
    ,case when t3.UNIT='亿元' then to_char(t1.BUDGET_VAL*100000000)
     when t3.UNIT='万元' then to_char(t1.BUDGET_VAL*10000)
else t1.BUDGET_VAL end as budget_val --None
    ,case when t3.UNIT='亿元' then t1.PROG_TARGET_VAL*100000000
     when t3.UNIT='万元' then t1.PROG_TARGET_VAL*10000
else t1.PROG_TARGET_VAL end as prog_target_val --None
    ,case when (t3.UNIT='%'and t3.index_name_mcs not like '%公司类授信客户分散度%')or nvl(t1.PROG_TARGET_VAL,0)=0 then null
     when t3.belong_cls='概览' then t1.INDEX_VALUE/t1.PROG_TARGET_VAL
else t1.IND_NET_INCRE/t1.PROG_TARGET_VAL end as tm_prog_cmplt_rat --None
    ,case when (t3.UNIT='%'and t3.index_name_mcs not like '%公司类授信客户分散度%') or nvl(t1.BUDGET_VAL,0)=0 then null
     else COALESCE(t1.IND_NET_INCRE,t1.index_value)/to_number(t1.BUDGET_VAL) end as year_cmplt_rat --None
    -- 10
    ,t3.UNIT as unit                                             --指标单位
    ,case when t3.UNIT='亿元' then t1.IND_NET_INCRE*100000000
     when t3.UNIT='万元' then t1.IND_NET_INCRE*10000
     when t3.UNIT='%' then null
else t1.IND_NET_INCRE end as ind_net_incre --None
    ,case when t3.UNIT='亿元' then t1.LAST_YEAR_BASE*100000000
     when t3.UNIT='万元' then t1.LAST_YEAR_BASE*10000
else t1.LAST_YEAR_BASE end as last_year_base --None
    ,case when t3.index_name_mcs like '%营业净收入%' or t3.super_index_name_mcs like '%营业净收入%' then
 case when substr('${batch_date}',5,2)='01' then nvl(t1.index_value,0)*decode(t3.UNIT,'亿元',100000000,'万元',10000,1) 
  else nvl(t1.index_value,0)*decode(t3.UNIT,'亿元',100000000,'万元',10000,1)-nvl(t2.index_value,0) end
else null end as m_acm_val --None
    ,nvl(t5.index_value, 0) as yoy_val                           --None
    -- 15
    ,nvl(t1.index_value, 0)*decode(t3.UNIT,'亿元',100000000,'万元',10000,1) - nvl(t5.index_value, 0) as yoy_chg_lmt --None
    ,case when nvl(t5.index_value, 0) > 0 then
             ((nvl(t1.index_value, 0)*decode(t3.UNIT,'亿元',100000000,'万元',10000,1) - nvl(t5.index_value, 0)) / nvl(t5.index_value, 0))
            else
             0
          end as yoy_chg_rat --None
    ,null as chain_val                                           --None
    ,null as chain_chg_lmt                                       --None
    ,null as chain_chg_rat                                       --None
    -- 20
    ,to_date('${batch_date}','yyyymmdd') as etl_dt               --None
    ,TO_TIMESTAMP('${batch_timestamp}','yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp --None
 from mc_ind_cmplt_situ_bl t1 --指标完成情况补录表 
LEFT JOIN mc_ind_cmplt_situ t2 --指标完成情况 
 on t1.index_no=t2.index_no
and t1.org_no=t2.org_no
and t2.etl_dt=to_date('${last_month_end}','yyyymmdd')
INNER JOIN mc_asses_index_define t3 --考核模块指标定义表 
 on t1.index_no=t3.index_no_mcs
and t3.index_state='在用'
and t3.module_name='条线FTP营收及主要指标完成情况'
and t3.etl_dt=to_date('${batch_date}','yyyymmdd')
LEFT JOIN mc_orga_para_jxkh t4 --绩效考核机构表 
 on t1.org_no=t4.org_no
LEFT JOIN mc_ind_cmplt_situ t5 --指标完成情况 
 on t1.index_no=t5.index_no
and t1.org_no=t5.org_no
and t5.etl_dt=to_date('${last_year_bath_date}','yyyymmdd')

where t1.etl_dt=to_date('${batch_date}','yyyymmdd')
 
;
commit;


/*==============第3组==============*/

--临时表01:FTP营业净收入完成情况、FTP净利润完成情况-补录
insert into ${idl_schema}.tmp_mc_ind_cmplt_situ_01(
    index_no                                                     --指标编号
    ,index_name                                                  --指标名称
    ,org_no                                                      --机构编号
    ,org_name                                                    --机构名称
    ,measure_no                                                  --度量编号
    -- 5
    ,index_value                                                 --指标值
    ,budget_val                                                  --预算值
    ,prog_target_val                                             --进度目标值
    ,tm_prog_cmplt_rat                                           --时间进度完成率
    ,year_cmplt_rat                                              --年度完成率
    -- 10
    ,unit                                                        --指标单位
    ,ind_net_incre                                               --指标净增值
    ,last_year_base                                              --上年基数
    ,m_acm_val                                                   --月累计值
    ,yoy_val                                                     --同比值
    -- 15
    ,yoy_chg_lmt                                                 --同比变动额
    ,yoy_chg_rat                                                 --同比变动率
    ,chain_val                                                   --环比值
    ,chain_chg_lmt                                               --环比变动额
    ,chain_chg_rat                                               --环比变动率
    -- 20
    ,etl_dt                                                      --ETL处理日期
    ,etl_timestamp                                               --ETL处理时间戳
)
select
    t3.INDEX_NO_MCS as index_no                                  --管驾指标编号
    ,t3.INDEX_NAME_MCS as index_name                             --管驾指标名称
    ,t1.ORG_NO as org_no                                         --机构编号
    ,t4.ORG_NAME as org_name                                     --机构名称
    ,'001' as measure_no                                         --None
    -- 5
    ,case when t3.UNIT='亿元' then t1.INDEX_VALUE*100000000 
     when t3.UNIT='万元' then t1.INDEX_VALUE*10000
else t1.INDEX_VALUE end as index_value --None
    ,case when t3.UNIT='亿元' then to_char(t1.BUDGET_VAL*100000000)
     when t3.UNIT='万元' then to_char(t1.BUDGET_VAL*10000)
else t1.BUDGET_VAL end as budget_val --None
    ,case when t3.UNIT='亿元' then t1.PROG_TARGET_VAL*100000000
     when t3.UNIT='万元' then t1.PROG_TARGET_VAL*10000
else t1.PROG_TARGET_VAL end as prog_target_val --None
    ,case when t3.UNIT='%' or nvl(t1.PROG_TARGET_VAL,0)=0 then null
else t1.INDEX_VALUE/t1.PROG_TARGET_VAL end as tm_prog_cmplt_rat --None
    ,case when t3.UNIT='%' or nvl(t1.BUDGET_VAL,0)=0 then null
     else t1.index_value/to_number(t1.BUDGET_VAL) end as year_cmplt_rat --None
    -- 10
    ,t3.UNIT as unit                                             --指标单位
    ,case when t3.UNIT='亿元' then t1.IND_NET_INCRE*100000000
     when t3.UNIT='万元' then t1.IND_NET_INCRE*10000
else t1.IND_NET_INCRE end as ind_net_incre --None
    ,case when t3.UNIT='亿元' then t1.LAST_YEAR_BASE*100000000
     when t3.UNIT='万元' then t1.LAST_YEAR_BASE*10000
else t1.LAST_YEAR_BASE end as last_year_base --None
    ,case when substr('${batch_date}',5,2)='01' then nvl(t1.index_value,0)*decode(t3.UNIT,'亿元',100000000,'万元',10000,1) 
  else nvl(t1.index_value,0)*decode(t3.UNIT,'亿元',100000000,'万元',10000,1)-nvl(t2.index_value,0) end as m_acm_val --None
    ,nvl(t5.index_value, 0) as yoy_val                           --None
    -- 15
    ,nvl(t1.index_value, 0)*decode(t3.UNIT,'亿元',100000000,'万元',10000,1) - nvl(t5.index_value, 0) as yoy_chg_lmt --None
    ,case when nvl(t5.index_value, 0) > 0 then
             ((nvl(t1.index_value, 0)*decode(t3.UNIT,'亿元',100000000,'万元',10000,1) - nvl(t5.index_value, 0)) / nvl(t5.index_value, 0))
            else
             0
          end as yoy_chg_rat --None
    ,null as chain_val                                           --None
    ,null as chain_chg_lmt                                       --None
    ,null as chain_chg_rat                                       --None
    -- 20
    ,to_date('${batch_date}','yyyymmdd') as etl_dt               --None
    ,TO_TIMESTAMP('${batch_timestamp}','yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp --None
 from mc_ind_cmplt_situ_bl t1 --指标完成情况补录表 
LEFT JOIN mc_ind_cmplt_situ t2 --指标完成情况补录表 
 on t1.index_no=t2.index_no
and t1.org_no=t2.org_no
and t2.etl_dt=to_date('${last_month_end}','yyyymmdd')
INNER JOIN mc_asses_index_define t3 --考核模块指标定义表 
 on t1.index_no=t3.index_no_mcs
and t3.index_state='在用'
and t3.module_name in ('FTP营业净收入完成情况','FTP净利润完成情况')
and t3.etl_dt=to_date('${batch_date}','yyyymmdd')
LEFT JOIN mc_orga_para_jxkh t4 --绩效考核机构表 
 on t1.org_no=t4.org_no
LEFT JOIN mc_ind_cmplt_situ t5 --指标完成情况 
 on t1.index_no=t5.index_no
and t1.org_no=t5.org_no
and t5.etl_dt=to_date('${last_year_bath_date}','yyyymmdd')

where t1.etl_dt=to_date('${batch_date}','yyyymmdd')
 
;
commit;


/*==============第4组==============*/

--临时表02:FTP营业净收入完成情况、FTP净利润完成情况-自动
whenever sqlerror continue none;
drop table ${idl_schema}.tmp_mc_ind_cmplt_situ_02 purge;
whenever sqlerror exit sql.sqlcode;
create table ${idl_schema}.tmp_mc_ind_cmplt_situ_02 (
    index_no varchar2(150)                                        --指标编号
    ,index_name varchar2(200) --指标名称
    ,org_no varchar2(150) --机构编号
    ,org_name varchar2(200) --机构名称
    ,measure_no varchar2(150) --度量编号
    -- 5
    ,index_value number(38,8) --指标值
    ,index_value_desc varchar2(200) --指标值备注
    ,budget_val varchar2(200) --预算值
    ,budget_val_desc varchar2(200) --预算值备注
    ,prog_target_val number(38,8) --进度目标值
    -- 10
    ,tm_prog_cmplt_rat number(38,8) --时间进度完成率
    ,tm_prog_cmplt_rat_desc varchar2(200) --时间进度完成率备注
    ,year_cmplt_rat number(38,8) --年度完成率
    ,year_cmplt_rat_desc varchar2(200) --年度完成率备注
    ,unit varchar2(150) --指标单位
    -- 15
    ,reach_std_situ varchar2(150) --达标情况
    ,ind_net_incre number(38,8) --指标净增值
    ,last_year_base number(38,8) --上年基数
    ,m_acm_val number(38,8) --月累计值
    ,yoy_val number(38,8) --同比值
    -- 20
    ,yoy_chg_lmt number(38,8) --同比变动额
    ,yoy_chg_rat number(38,8) --同比变动率
    ,chain_val number(38,8) --环比值
    ,chain_chg_lmt number(38,8) --环比变动额
    ,chain_chg_rat number(38,8) --环比变动率
    -- 25
    ,etl_dt date --ETL处理日期
    ,etl_timestamp timestamp(6) --ETL处理时间戳
)
 ;

insert into ${idl_schema}.tmp_mc_ind_cmplt_situ_02(
    index_no                                                     --指标编号
    ,index_name                                                  --指标名称
    ,org_no                                                      --机构编号
    ,org_name                                                    --机构名称
    ,measure_no                                                  --度量编号
    -- 5
    ,index_value                                                 --指标值
    ,index_value_desc                                            --指标值备注
    ,budget_val                                                  --预算值
    ,budget_val_desc                                             --预算值备注
    ,prog_target_val                                             --进度目标值
    -- 10
    ,tm_prog_cmplt_rat                                           --时间进度完成率
    ,tm_prog_cmplt_rat_desc                                      --时间进度完成率备注
    ,year_cmplt_rat                                              --年度完成率
    ,year_cmplt_rat_desc                                         --年度完成率备注
    ,unit                                                        --指标单位
    -- 15
    ,reach_std_situ                                              --达标情况
    ,ind_net_incre                                               --指标净增值
    ,last_year_base                                              --上年基数
    ,m_acm_val                                                   --月累计值
    ,yoy_val                                                     --同比值
    -- 20
    ,yoy_chg_lmt                                                 --同比变动额
    ,yoy_chg_rat                                                 --同比变动率
    ,chain_val                                                   --环比值
    ,chain_chg_lmt                                               --环比变动额
    ,chain_chg_rat                                               --环比变动率
    -- 25
    ,etl_dt                                                      --ETL处理日期
    ,etl_timestamp                                               --ETL处理时间戳
)
select
    t4.index_no_mcs as index_no                                  --None
    ,t4.index_name_mcs as index_name                             --None
    ,t1.org_no as org_no                                         --None
    ,t1.org_name as org_name                                     --None
    ,'001' as measure_no                                         --None
    -- 5
    ,t3.zbz as index_value                                       --None
    ,'' as index_value_desc                                      --None
    ,t3.ndmbz as budget_val                                      --None
    ,'' as budget_val_desc                                       --None
    ,t3.sjjdz as prog_target_val                                 --None
    -- 10
    ,t3.sjjdwcl/100 as tm_prog_cmplt_rat                         --None
    ,'' as tm_prog_cmplt_rat_desc                                --None
    ,t3.ndwcl/100 as year_cmplt_rat                              --None
    ,'' as year_cmplt_rat_desc                                   --None
    ,t4.unit as unit                                             --None
    -- 15
    ,'' as reach_std_situ                                        --None
    ,t3.jzz as ind_net_incre                                     --None
    ,t3.js as last_year_base                                     --None
    ,case when substr('${batch_date}',5,2)='01' then nvl(t3.zbz,0) 
          when substr('${batch_date}',5,2)<>'01' and t4.ind_stat_type = '累计值' then nvl(t3.zbz,0)-nvl(T7.index_value,0) 
              else nvl(t3.zbz,0) END as m_acm_val --None
    ,case when t4.ind_stat_type = '累计值' then nvl(t6.zbz, 0) end as yoy_val --None
    -- 20
    ,case when t4.ind_stat_type = '累计值' then nvl(t3.zbz, 0) - nvl(t6.zbz, 0) end as yoy_chg_lmt --None
    ,case when t4.ind_stat_type = '累计值' then (case
            when nvl(t6.zbz, 0) > 0 then
             (nvl(t3.zbz, 0) - nvl(t6.zbz, 0)) / nvl(t6.zbz, 0)
            else
             0
          end)
end as yoy_chg_rat --None
    ,null as chain_val                                           --None
    ,null as chain_chg_lmt                                       --None
    ,null as chain_chg_rat                                       --None
    -- 25
    ,to_date('${batch_date}','yyyymmdd') as etl_dt               --None
    ,TO_TIMESTAMP('${batch_timestamp}','yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp --None
 from mc_orga_para_jxkh t1 --绩效考核机构表 
LEFT JOIN itl_edw_pams_khdx_jg t2 --考核对象-机构 
 on t1.org_no=t2.jgdh
 and t2.etl_dt = to_date('${batch_date}','yyyymmdd')
INNER JOIN itl_edw_pams_jxbb_kpikhdfmx_jg t3 --绩效报表_KPI考核得分明细_机构 
 on t3.tjrq = '${batch_date}'
 and t3.khdxdh = t2.khdxdh
INNER JOIN mc_asses_index_define t4 --考核模块指标定义表 
 on t4.etl_dt=to_date('${batch_date}','yyyymmdd')
and t4.module_name in ('FTP净利润完成情况','FTP营业净收入完成情况')
and regexp_substr(t4.index_no, 'fabh:(\d+)', 1, 1, null, 1) = t3.fabh
and regexp_substr(t4.index_no, 'xh:(\d+)', 1, 1, null, 1) = t3.xh
LEFT JOIN itl_edw_pams_khfa_khzb_jg t5 --考核方案-考核指标-机构 
 on t5.etl_dt=to_date('${batch_date}','yyyymmdd')
and regexp_substr(t4.index_no, 'khzbdh:(\d+)', 1, 1, null, 1) = t5.khzbdh
LEFT JOIN itl_edw_pams_v_yjzb_jg t6 --业绩指标-机构 
 on t6.etl_dt=to_date((case when t4.IND_STAT_TYPE='累计值' then '${last_year_bath_date}' else '${last_month_end}' end),'yyyymmdd')
and t6.tjrq=to_number(case when t4.IND_STAT_TYPE='累计值' then '${last_year_bath_date}' else '${last_month_end}' end)
and t6.zbdh=t5.zbdh
and t6.sdbs=t5.sdbs
and t6.bz=t5.bz
and t6.tjkj=t5.tjkj
and t6.khdxdh=t3.khdxdh
LEFT JOIN mc_ind_cmplt_situ t7 --None 
 on t4.index_no_mcs = T7.index_no
and t1.org_no = T7.org_no
AND T7.etl_dt=to_date('${last_month_end}','yyyymmdd')
where t1.org_level in ('分行', '条线管理部门', '事业部')
 and t1.remark is not null
 ;
commit;


/*==============第5组==============*/

--临时表02:条线FTP营收及主要指标完成情况-自动
insert into ${idl_schema}.tmp_mc_ind_cmplt_situ_02(
    index_no                                                     --指标编号
    ,index_name                                                  --指标名称
    ,org_no                                                      --机构编号
    ,org_name                                                    --机构名称
    ,measure_no                                                  --度量编号
    -- 5
    ,index_value                                                 --指标值
    ,budget_val                                                  --预算值
    ,prog_target_val                                             --进度目标值
    ,tm_prog_cmplt_rat                                           --时间进度完成率
    ,year_cmplt_rat                                              --年度完成率
    -- 10
    ,unit                                                        --指标单位
    ,ind_net_incre                                               --指标净增值
    ,last_year_base                                              --上年基数
    ,m_acm_val                                                   --月累计值
    ,yoy_val                                                     --同比值
    -- 15
    ,yoy_chg_lmt                                                 --同比变动额
    ,yoy_chg_rat                                                 --同比变动率
    ,chain_val                                                   --环比值
    ,chain_chg_lmt                                               --环比变动额
    ,chain_chg_rat                                               --环比变动率
    -- 20
    ,etl_dt                                                      --ETL处理日期
    ,etl_timestamp                                               --ETL处理时间戳
)
select
    t7.index_no_mcs as index_no                                  --None
    ,t7.index_name_mcs as index_name                             --None
    ,t6.org_no as org_no                                         --None
    ,t6.org_name as org_name                                     --None
    ,'001' as measure_no                                         --None
    -- 5
    ,t4.zbz as index_value                                       --None
    ,t4.ndmbz as budget_val                                      --None
    ,t4.sjjdz as prog_target_val                                 --None
    ,t4.sjjdwcl/100 as tm_prog_cmplt_rat                         --None
    ,t4.ndwcl/100 as year_cmplt_rat                              --None
    -- 10
    ,t7.unit as unit                                             --None
    ,t4.jzz as ind_net_incre                                     --None
    ,t4.js as last_year_base                                     --None
    ,null as m_acm_val                                           --None
    ,case when t7.ind_stat_type = '累计值' then nvl(T8.index_value, 0) end as yoy_val --None
    -- 15
    ,case when t7.ind_stat_type = '累计值' then nvl(t4.zbz, 0) - nvl(T8.index_value, 0) end as yoy_chg_lmt --None
    ,case when t7.ind_stat_type = '累计值' then (case
            when nvl(T8.index_value, 0) > 0 then
             (nvl(t4.zbz, 0) - nvl(T8.index_value, 0)) / nvl(T8.index_value, 0)
            else
             0
          end)
       end as yoy_chg_rat --None
    ,case when t7.ind_stat_type = '时点值' then nvl(T9.index_value, 0) end as chain_val --None
    ,case when t7.ind_stat_type = '时点值' then nvl(t4.zbz, 0) - nvl(T9.index_value, 0) end as chain_chg_lmt --None
    ,case when t7.ind_stat_type = '时点值' then (case
            when nvl(T9.index_value, 0) > 0 then
             (nvl(t4.zbz, 0) - nvl(T9.index_value, 0)) / nvl(T9.index_value, 0)
            else
             0
          end)
end as chain_chg_rat --None
    -- 20
    ,to_date('${batch_date}','yyyymmdd') as etl_dt               --None
    ,TO_TIMESTAMP('${batch_timestamp}','yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp --None
 from itl_edw_pams_khfa_fapz T1 --None 
INNER JOIN itl_edw_pams_khfa_level_manage T2 --None 
 on t2.fabh = t1.fabh
 and t2.etl_dt = to_date('${batch_date}','yyyymmdd')
INNER JOIN itl_edw_pams_khfa_khzb_jg T3 --None 
 on t3.etl_dt = to_date('${batch_date}','yyyymmdd')
 and t3.khzbdh = t2.khzbbh
INNER JOIN itl_edw_pams_jxbb_kpikhdfmx_jg T4 --None 
 on t4.tjrq = '${batch_date}'
  and t4.fabh=t2.fabh
  and t4.xh=t2.xh
INNER JOIN itl_edw_pams_khdx_jg T5 --None 
 on t5.etl_dt = to_date('${batch_date}','yyyymmdd')
  and t5.khdxdh=t4.khdxdh
INNER JOIN mc_orga_para_jxkh T6 --None 
 on t6.org_no=t5.jgdh
 and t6.org_level in ('分行','事业部','条线管理部门')
 and t6.remark is not null
LEFT JOIN mc_asses_index_define T7 --None 
 on t7.etl_dt = to_date('${batch_date}','yyyymmdd')
 and t7.module_name ='条线FTP营收及主要指标完成情况'
 and t7.belong_cls <>'概览'
 and t7.index_no=t3.khzbdh
LEFT JOIN mc_ind_cmplt_situ T8 --None 
 on t7.index_no_mcs = T8.index_no
and t6.org_no = t8.org_no
AND t8.ETL_DT = ADD_MONTHS(to_date('${batch_date}','yyyymmdd'),-12)
LEFT JOIN mc_ind_cmplt_situ T9 --None 
 on t7.index_no_mcs = T9.index_no
and t6.org_no = T9.org_no
AND T9.ETL_DT = ADD_MONTHS(to_date('${batch_date}','yyyymmdd'),-1)

where t1.zt = '1' --方案状态为在用
 and t1.khdx = '1' --考核对象是机构
 and t1.khnf <> 2025 --只从2026年开始
 and t1.yybzz = 0 --只要考核的指标方案
 and t1.etl_dt = to_date('${batch_date}', 'yyyymmdd')
 
;
commit;


/*==============第6组==============*/

--指标完成情况:插入目标表
insert into ${idl_schema}.mc_ind_cmplt_situ(
    index_no                                                     --指标编号
    ,index_name                                                  --指标名称
    ,org_no                                                      --机构编号
    ,org_name                                                    --机构名称
    ,measure_no                                                  --度量编号
    -- 5
    ,index_value                                                 --指标值
    ,index_value_desc                                            --指标值备注
    ,budget_val                                                  --预算值
    ,budget_val_desc                                             --预算值备注
    ,prog_target_val                                             --进度目标值
    -- 10
    ,tm_prog_cmplt_rat                                           --时间进度完成率
    ,tm_prog_cmplt_rat_desc                                      --时间进度完成率备注
    ,year_cmplt_rat                                              --年度完成率
    ,year_cmplt_rat_desc                                         --年度完成率备注
    ,unit                                                        --指标单位
    -- 15
    ,reach_std_situ                                              --达标情况
    ,ind_net_incre                                               --指标净增值
    ,last_year_base                                              --上年基数
    ,m_acm_val                                                   --月累计值
    ,yoy_val                                                     --同比值
    -- 20
    ,yoy_chg_lmt                                                 --同比变动额
    ,yoy_chg_rat                                                 --同比变动率
    ,chain_val                                                   --环比值
    ,chain_chg_lmt                                               --环比变动额
    ,chain_chg_rat                                               --环比变动率
    -- 25
    ,etl_dt                                                      --ETL处理日期
    ,etl_timestamp                                               --ETL处理时间戳
)
select
    coalesce(t2.INDEX_NO,t1.INDEX_NO) as index_no                --None
    ,coalesce(t2.INDEX_NAME,t1.INDEX_NAME) as index_name         --None
    ,coalesce(t2.ORG_NO,t1.ORG_NO) as org_no                     --None
    ,coalesce(t2.ORG_NAME,t1.ORG_NAME) as org_name               --None
    ,coalesce(t2.MEASURE_NO,t1.MEASURE_NO) as measure_no         --None
    -- 5
    ,coalesce(t2.INDEX_VALUE,t1.INDEX_VALUE) as index_value      --None
    ,coalesce(t2.INDEX_VALUE_DESC,t1.INDEX_VALUE_DESC) as index_value_desc --None
    ,coalesce(t2.BUDGET_VAL,t1.BUDGET_VAL) as budget_val         --None
    ,coalesce(t2.BUDGET_VAL_DESC,t1.BUDGET_VAL_DESC) as budget_val_desc --None
    ,coalesce(t2.PROG_TARGET_VAL,t1.PROG_TARGET_VAL) as prog_target_val --None
    -- 10
    ,coalesce(t2.TM_PROG_CMPLT_RAT,t1.TM_PROG_CMPLT_RAT) as tm_prog_cmplt_rat --None
    ,coalesce(t2.TM_PROG_CMPLT_RAT_DESC,t1.TM_PROG_CMPLT_RAT_DESC) as tm_prog_cmplt_rat_desc --None
    ,coalesce(t2.YEAR_CMPLT_RAT,t1.YEAR_CMPLT_RAT) as year_cmplt_rat --None
    ,coalesce(t2.YEAR_CMPLT_RAT_DESC,t1.YEAR_CMPLT_RAT_DESC) as year_cmplt_rat_desc --None
    ,coalesce(t2.UNIT,t1.UNIT) as unit                           --None
    -- 15
    ,coalesce(t2.REACH_STD_SITU,t1.REACH_STD_SITU) as reach_std_situ --None
    ,coalesce(t2.IND_NET_INCRE,t1.IND_NET_INCRE) as ind_net_incre --None
    ,coalesce(t2.LAST_YEAR_BASE,t1.LAST_YEAR_BASE) as last_year_base --None
    ,coalesce(t2.M_ACM_VAL,t1.M_ACM_VAL) as m_acm_val            --None
    ,coalesce(t2.YOY_VAL,t1.YOY_VAL) as yoy_val                  --None
    -- 20
    ,coalesce(t2.YOY_CHG_LMT,t1.YOY_CHG_LMT) as yoy_chg_lmt      --None
    ,coalesce(t2.YOY_CHG_RAT,t1.YOY_CHG_RAT) as yoy_chg_rat      --None
    ,coalesce(t2.CHAIN_VAL,t1.CHAIN_VAL) as chain_val            --None
    ,coalesce(t2.CHAIN_CHG_LMT,t1.CHAIN_CHG_LMT) as chain_chg_lmt --None
    ,coalesce(t2.CHAIN_CHG_RAT,t1.CHAIN_CHG_RAT) as chain_chg_rat --None
    -- 25
    ,to_date('${batch_date}','yyyymmdd') as etl_dt               --None
    ,TO_TIMESTAMP('${batch_timestamp}','yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp --None
 from tmp_mc_ind_cmplt_situ_02 T1 --None 
FULL JOIN tmp_mc_ind_cmplt_situ_01 T2 --None 
 on t1.org_no=t2.org_no
 and t1.index_no=t2.index_no
 and t1.index_name=t2.index_name
 and t1.etl_dt = t2.etl_dt

where t1.etl_dt = to_date('${batch_date}','yyyymmdd') 
 or t2.etl_dt = to_date('${batch_date}','yyyymmdd')
 
;
commit;

--delete tmp table
whenever sqlerror continue none;
drop table ${idl_schema}.tmp_mc_ind_cmplt_situ_01 purge;
drop table ${idl_schema}.tmp_mc_ind_cmplt_situ_02 purge;

-- 3.1 gather table status
exec dbms_stats.gather_table_stats(ownname => '${idl_schema}', tabname => 'mc_ind_cmplt_situ', partname => 'p_${batch_date}', granularity => 'PARTITION', degree => 8, cAScade => true);
