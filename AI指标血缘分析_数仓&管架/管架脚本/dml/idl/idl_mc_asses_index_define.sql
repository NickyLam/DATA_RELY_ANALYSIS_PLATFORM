/*
Purpose:    IDL-考核模块指标定义表
Creater:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd idl_mc_asses_index_define
CreateDate: None
FileType:   DML
Logs:
    表英文名： mc_asses_index_define
    表中文名： 考核模块指标定义表
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
        2026-03-17    郑沛隆    新建脚本    
        2026-03-23    郑沛隆    调整营收、利润的管驾指标名称    
        2026-04-20    郑沛隆    调整KPI得分情况指标内容    
*/


--设置参数
set timing on
-- 0.1 alter parallel
alter session force parallel query parallel 8;
alter session force parallel dml parallel 8;
-- 1.1 create table for exchage
whenever sqlerror continue none;
alter table ${idl_schema}.mc_asses_index_define add partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));
alter table ${idl_schema}.mc_asses_index_define truncate partition p_${batch_date};

whenever sqlerror exit sql.sqlcode; 

/*==============第1组==============*/

--考核模块指标定义表:KPI得分情况
insert into ${idl_schema}.mc_asses_index_define(
    module_name                                                  --模块名称
    ,belong_cls                                                  --所属分类
    ,index_class_f_mcs                                           --指标一级分类
    ,index_class_s_mcs                                           --指标二级分类
    ,index_class_t_mcs                                           --指标三级分类
    -- 5
    ,index_no                                                    --取值指标编号
    ,index_name                                                  --取值指标名称
    ,index_no_mcs                                                --管驾指标编号
    ,index_name_mcs                                              --管驾指标名称
    ,source_system                                               --来源系统
    -- 10
    ,frequency                                                   --指标频度
    ,unit                                                        --指标单位
    ,index_state                                                 --指标状态
    ,update_dt                                                   --更新日期
    ,update_per                                                  --更新人
    -- 15
    ,super_index_no_mcs                                          --上级管驾指标编号
    ,super_index_name_mcs                                        --上级管驾指标名称
    ,etl_dt                                                      --ETL处理日期
    ,etl_timestamp                                               --ETL处理时间戳
)
select
    'KPI得分情况' as module_name                                     --None
    ,t1.org_level as belong_cls                                  --None
    ,case when t1.org_level in ('事业部','条线管理部门') then t1.org_name end as index_class_f_mcs --None
    ,'' as index_class_s_mcs                                     --None
    ,''  as index_class_t_mcs                                    --None
    -- 5
    ,'fabh:' || t4.fabh || ',xh:' || t4.xh|| ',khzbdh:' || t4.KHZBBH as index_no --None
    ,t4.jg as index_name                                         --None
    ,'KPI06' || lpad(to_char(case t1.org_level
                                 when '分行' then
                                  '001'
                                 when '事业部' then
                                  '002'
                                 when '条线管理部门' then
                                  '003' end),3,'0') ||to_char(t5.khnf)||to_char(t4.fabh)||lpad(to_char(t4.xh), 3, '0') as index_no_mcs --None
    ,t4.jg as index_name_mcs                                     --None
    ,'绩效系统' as source_system                                     --None
    -- 10
    ,'月' as frequency                                            --None
    ,decode(t6.dw, '1', '万元', '2', '户', '3', '笔', '4', '%', t6.dw) as unit --None
    ,'在用' as index_state                                         --None
    ,'' as update_dt                                             --None
    ,'' as update_per                                            --None
    -- 15
    ,case when t4.lx = '1'and t4.khzbbh = 0 then
          null
         else
          'KPI06' || lpad(to_char(case t1.org_level
                                 when '分行' then
                                  '001'
                                 when '事业部' then
                                  '002'
                                 when '条线管理部门' then
                                  '003'
                               end),3,'0') ||to_char(t5.khnf)||to_char(t7.fabh)||lpad(to_char(t7.start_no), 3, '0') end as super_index_no_mcs --None
    ,case when t4.lx = '1'and t4.khzbbh = 0 then null else t7.super_index_name end as super_index_name_mcs --None
    ,to_date('${batch_date}','yyyymmdd') as etl_dt               --None
    ,TO_TIMESTAMP('${batch_timestamp}','yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp --None
 from mc_orga_para_jxkh t1 --绩效考核机构表 
INNER JOIN itl_edw_pams_khfa_fapz t5 --考核方案-方案配置 
 on t5.etl_dt = to_date('${batch_date}', 'yyyymmdd')
 and t5.zt = '1' --方案状态为在用
 and t5.khdx = '1' --考核对象是机构
 and t5.khnf =to_number(extract(year from to_date('${batch_date}', 'yyyymmdd')))
 and t5.yybzz > 0 --只要考核的指标方案
 and t5.fabh = (case when t1.org_level='分行' then '168'
                   when t1.org_level='事业部' and t1.org_no='800892' then '158' --资产管理事业部
                   when t1.org_level='事业部' and t1.org_no='800976' then '157' --资金交易部
                   when t1.org_level='事业部' and t1.org_no='800935' then '161' --票据业务部
                   when t1.org_level='条线管理部门' and t1.org_no='800716' then '162' --零售信贷部
                   when t1.org_level='条线管理部门' and t1.org_no='800721' then '163' --零售金融部
                   when t1.org_level='条线管理部门' and t1.org_no='800881' then '159' --战略客户部
                   when t1.org_level='条线管理部门' and t1.org_no='800891' then '166' --产业金融部
                   when t1.org_level='条线管理部门' and t1.org_no='800954' then '165' --公司银行部
                   when t1.org_level='条线管理部门' and t1.org_no='800957' then '167' --财富管理部
                   when t1.org_level='条线管理部门' and t1.org_no='800968' then '164' --交易银行部
                   when t1.org_level='条线管理部门' and t1.org_no='800975' then '160' --投资银行部
               end)
INNER JOIN itl_edw_pams_khfa_level_manage t4 --考核方案层级管理 
 on t4.etl_dt = to_date('${batch_date}', 'yyyymmdd')
 and t4.fabh = t5.fabh
LEFT JOIN ( select jhmc,khzbdh,khnf,dw,row_number()over(partition by jhmc,khzbdh,khnf order by lrsj desc) as rn
from itl_edw_pams_khfa_khjhgl_mx
where etl_dt=to_date('${batch_date}', 'yyyymmdd')) t6 --考核方案_考核计划管理_明细 
 on t6.jhmc = t5.famc
 and t6.khzbdh = t4.khzbbh
 and t6.khnf = t5.khnf
 and t6.rn=1
LEFT JOIN (select t1.fabh,
        t1.jg as super_index_name,
       t1.xh as start_no,
       lead(t1.xh) over(partition by t1.fabh order by t1.xh) as end_no
  from itl_edw_pams_khfa_level_manage t1
 where t1.etl_dt = to_date('${batch_date}', 'yyyymmdd')
   and t1.lx = '1'
   and t1.khzbbh = 0
) t7 --获取指标大类区间 
 on t7.fabh = t4.fabh
 and t4.xh > t7.start_no
 and (t4.xh < t7.end_no or t7.end_no is null)

where t1.org_level in ('分行', '条线管理部门', '事业部')
 and t1.remark is not null
GROUP BY t1.org_level
,case when t1.org_level in ('事业部','条线管理部门') then t1.org_name end
,'fabh:' || t4.fabh || ',xh:' || t4.xh|| ',khzbdh:' || t4.KHZBBH
,t4.jg
,'KPI06' || lpad(to_char(case t1.org_level
                                 when '分行' then
                                  '001'
                                 when '事业部' then
                                  '002'
                                 when '条线管理部门' then
                                  '003' end),3,'0') ||to_char(t5.khnf)||to_char(t4.fabh)||lpad(to_char(t4.xh), 3, '0')
,decode(t6.dw, '1', '万元', '2', '户', '3', '笔', '4', '%', t6.dw)
,case when t4.lx = '1'and t4.khzbbh = 0 then
          null
         else
          'KPI06' || lpad(to_char(case t1.org_level
                                 when '分行' then
                                  '001'
                                 when '事业部' then
                                  '002'
                                 when '条线管理部门' then
                                  '003'
                               end),3,'0') ||to_char(t5.khnf)||to_char(t7.fabh)||lpad(to_char(t7.start_no), 3, '0') end
,case when t4.lx = '1'and t4.khzbbh = 0 then null else t7.super_index_name end
;
commit;


/*==============第2组==============*/

--考核模块指标定义表:FTP营业净收入完成情况
insert into ${idl_schema}.mc_asses_index_define(
    module_name                                                  --模块名称
    ,belong_cls                                                  --所属分类
    ,index_class_f_mcs                                           --指标一级分类
    ,index_class_s_mcs                                           --指标二级分类
    ,index_class_t_mcs                                           --指标三级分类
    -- 5
    ,index_no                                                    --取值指标编号
    ,index_name                                                  --取值指标名称
    ,index_no_mcs                                                --管驾指标编号
    ,index_name_mcs                                              --管驾指标名称
    ,source_system                                               --来源系统
    -- 10
    ,frequency                                                   --指标频度
    ,unit                                                        --指标单位
    ,index_state                                                 --指标状态
    ,update_dt                                                   --更新日期
    ,update_per                                                  --更新人
    -- 15
    ,super_index_no_mcs                                          --上级管驾指标编号
    ,super_index_name_mcs                                        --上级管驾指标名称
    ,ind_stat_type                                               --指标统计类型
    ,etl_dt                                                      --ETL处理日期
    ,etl_timestamp                                               --ETL处理时间戳
    -- 20
)
select
    'FTP营业净收入完成情况' as module_name                                --None
    ,'' as belong_cls                                            --None
    ,'' as index_class_f_mcs                                     --None
    ,'' as index_class_s_mcs                                     --None
    ,''  as index_class_t_mcs                                    --None
    -- 5
    ,'fabh:' || t4.fabh || ',xh:' || t4.xh||',khzbdh:' || t4.khzbdh||',zbdh:' || t1.zbdh as index_no --None
    ,t2.zbmc as index_name                                       --None
    ,'KPI03001' ||to_char(t3.khnf)||to_char(t3.fabh)|| lpad(t4.xh, 3, '0') as index_no_mcs --None
    ,case when t1.zbdh ='20011989' then 'FTP营业净收入_冲减前'
     when t1.zbdh ='20012000' then 'FTP营业净收入_冲减后' end as index_name_mcs --None
    ,'绩效系统' as source_system                                     --None
    -- 10
    ,'月' as frequency                                            --None
    ,'万元' as unit                                                --None
    ,'在用' as index_state                                         --None
    ,'' as update_dt                                             --None
    ,'' as update_per                                            --None
    -- 15
    ,'' as super_index_no_mcs                                    --None
    ,'' as super_index_name_mcs                                  --None
    ,case when t1.sdbs='1' then '时点值' else '累计值' end as ind_stat_type --None
    ,to_date('${batch_date}','yyyymmdd') as etl_dt               --None
    ,TO_TIMESTAMP('${batch_timestamp}','yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp --None
    -- 20
 from itl_edw_pams_khfa_fapz t3 --考核方案-方案配置 
INNER JOIN itl_edw_pams_khfa_khzbpz t4 --考核方案_考核指标配置 
 on t4.etl_dt = to_date('${batch_date}', 'yyyymmdd')
 and t4.fabh=t3.fabh
INNER JOIN itl_edw_pams_khfa_khzb_jg t1 --考核方案-考核指标-机构 
 on t1.etl_dt = to_date('${batch_date}', 'yyyymmdd')
 and t1.khzbdh=t4.khzbdh
 and t1.zbdh in ('20011989','20012000')--FTP营业净收入_冲减前 FTP营业净收入_冲减后
LEFT JOIN itl_edw_pams_khdx_zb t2 --考核对象-指标 
 on t2.etl_dt = to_date('${batch_date}', 'yyyymmdd')
 and t1.zbdh = t2.zbdh

where t3.etl_dt = to_date('${batch_date}', 'yyyymmdd')
 and t3.zt = '1' --方案状态为在用
 and t3.khdx = '1' --考核对象是机构
 and t3.khnf = to_number(extract(year from to_date('${batch_date}', 'yyyymmdd')))
 and t3.yybzz > 0 --只要考核的指标方案
 
;
commit;


/*==============第3组==============*/

--考核模块指标定义表:FTP净利润完成情况
insert into ${idl_schema}.mc_asses_index_define(
    module_name                                                  --模块名称
    ,belong_cls                                                  --所属分类
    ,index_class_f_mcs                                           --指标一级分类
    ,index_class_s_mcs                                           --指标二级分类
    ,index_class_t_mcs                                           --指标三级分类
    -- 5
    ,index_no                                                    --取值指标编号
    ,index_name                                                  --取值指标名称
    ,index_no_mcs                                                --管驾指标编号
    ,index_name_mcs                                              --管驾指标名称
    ,source_system                                               --来源系统
    -- 10
    ,frequency                                                   --指标频度
    ,unit                                                        --指标单位
    ,index_state                                                 --指标状态
    ,update_dt                                                   --更新日期
    ,update_per                                                  --更新人
    -- 15
    ,super_index_no_mcs                                          --上级管驾指标编号
    ,super_index_name_mcs                                        --上级管驾指标名称
    ,ind_stat_type                                               --指标统计类型
    ,etl_dt                                                      --ETL处理日期
    ,etl_timestamp                                               --ETL处理时间戳
    -- 20
)
select
    'FTP净利润完成情况' as module_name                                  --None
    ,'' as belong_cls                                            --None
    ,'' as index_class_f_mcs                                     --None
    ,'' as index_class_s_mcs                                     --None
    ,''  as index_class_t_mcs                                    --None
    -- 5
    ,'fabh:' || t4.fabh || ',xh:' || t4.xh||',khzbdh:' || t4.khzbdh||',zbdh:' || t1.zbdh as index_no --None
    ,t2.zbmc as index_name                                       --None
    ,'KPI03001' ||to_char(t3.khnf)||to_char(t3.fabh)|| lpad(t4.xh, 3, '0') as index_no_mcs --None
    ,case when t1.zbdh ='20012041' then 'FTP净利润_冲减前'
     when t1.zbdh ='29501278' then 'FTP净利润_冲减后' end as index_name_mcs --None
    ,'绩效系统' as source_system                                     --None
    -- 10
    ,'月' as frequency                                            --None
    ,'万元' as unit                                                --None
    ,'在用' as index_state                                         --None
    ,'' as update_dt                                             --None
    ,'' as update_per                                            --None
    -- 15
    ,'' as super_index_no_mcs                                    --None
    ,'' as super_index_name_mcs                                  --None
    ,case when t1.sdbs='1' then '时点值' else '累计值' end as ind_stat_type --None
    ,to_date('${batch_date}','yyyymmdd') as etl_dt               --None
    ,TO_TIMESTAMP('${batch_timestamp}','yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp --None
    -- 20
 from itl_edw_pams_khfa_fapz t3 --考核方案-方案配置 
INNER JOIN itl_edw_pams_khfa_khzbpz t4 --考核方案_考核指标配置 
 on t4.etl_dt = to_date('${batch_date}', 'yyyymmdd')
 and t4.fabh=t3.fabh
INNER JOIN itl_edw_pams_khfa_khzb_jg t1 --考核方案-考核指标-机构 
 on t1.etl_dt = to_date('${batch_date}', 'yyyymmdd')
 and t1.khzbdh=t4.khzbdh
 and t1.zbdh  in ('20012041','29501278') --FTP净利润_冲减前 FTP净利润_冲减后
LEFT JOIN itl_edw_pams_khdx_zb t2 --考核对象-指标 
 on t2.etl_dt = to_date('${batch_date}', 'yyyymmdd')
 and t1.zbdh = t2.zbdh

where t3.etl_dt = to_date('${batch_date}', 'yyyymmdd')
 and t3.zt = '1' --方案状态为在用
 and t3.khdx = '1' --考核对象是机构
 and t3.khnf = to_number(extract(year from to_date('${batch_date}', 'yyyymmdd')))
 and t3.yybzz > 0 --只要考核的指标方案
 
;
commit;


/*==============第4组==============*/

--考核模块指标定义表:其他
insert into ${idl_schema}.mc_asses_index_define(
    module_name                                                  --模块名称
    ,belong_cls                                                  --所属分类
    ,index_class_f_mcs                                           --指标一级分类
    ,index_class_s_mcs                                           --指标二级分类
    ,index_class_t_mcs                                           --指标三级分类
    -- 5
    ,index_no                                                    --取值指标编号
    ,index_name                                                  --取值指标名称
    ,index_no_mcs                                                --管驾指标编号
    ,index_name_mcs                                              --管驾指标名称
    ,source_system                                               --来源系统
    -- 10
    ,frequency                                                   --指标频度
    ,unit                                                        --指标单位
    ,index_state                                                 --指标状态
    ,update_dt                                                   --更新日期
    ,update_per                                                  --更新人
    -- 15
    ,super_index_no_mcs                                          --上级管驾指标编号
    ,super_index_name_mcs                                        --上级管驾指标名称
    ,ind_stat_type                                               --指标统计类型
    ,etl_dt                                                      --ETL处理日期
    ,etl_timestamp                                               --ETL处理时间戳
    -- 20
)
select
    t1.MODULE_NAME as module_name                                --None
    ,t1.BELONG_CLS as belong_cls                                 --None
    ,t1.INDEX_CLASS_F_MCS as index_class_f_mcs                   --None
    ,t1.INDEX_CLASS_S_MCS as index_class_s_mcs                   --None
    ,t1.INDEX_CLASS_T_MCS as index_class_t_mcs                   --None
    -- 5
    ,t1.INDEX_NO as index_no                                     --None
    ,t1.INDEX_NAME as index_name                                 --None
    ,t1.INDEX_NO_MCS as index_no_mcs                             --None
    ,t1.INDEX_NAME_MCS as index_name_mcs                         --None
    ,t1.SOURCE_SYSTEM as source_system                           --None
    -- 10
    ,t1.FREQUENCY as frequency                                   --None
    ,t1.UNIT as unit                                             --None
    ,t1.INDEX_STATE as index_state                               --None
    ,t1.UPDATE_DT as update_dt                                   --None
    ,t1.UPDATE_PER as update_per                                 --None
    -- 15
    ,t1.SUPER_INDEX_NO_MCS as super_index_no_mcs                 --None
    ,t1.SUPER_INDEX_NAME_MCS as super_index_name_mcs             --None
    ,t1.IND_STAT_TYPE as ind_stat_type                           --None
    ,to_date('${batch_date}','yyyymmdd') as etl_dt               --None
    ,TO_TIMESTAMP('${batch_timestamp}','yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp --None
    -- 20
 from mc_asses_index_define t1 --考核模块指标定义表 

where t1.etl_dt=to_date('${last_month_end}', 'yyyymmdd')
 and t1.module_name not in ('KPI得分情况','FTP净利润完成情况','FTP营业净收入完成情况')
 
;
commit;

--delete tmp table
whenever sqlerror continue none;

-- 3.1 gather table status
exec dbms_stats.gather_table_stats(ownname => '${idl_schema}', tabname => 'mc_asses_index_define', partname => 'p_${batch_date}', granularity => 'PARTITION', degree => 8, cAScade => true);
