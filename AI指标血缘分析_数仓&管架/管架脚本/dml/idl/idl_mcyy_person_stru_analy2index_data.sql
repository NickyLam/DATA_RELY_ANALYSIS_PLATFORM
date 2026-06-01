/*
Purpose:    指标应用层-职业人员结构分析月报表，清空目标表当天分区数据，把当天数据与目标表进行分区交换.此脚本由生成引擎自动生成.
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd idl_mcyy_person_stru_analy2index_data
CreateDate: 20210913
修改记录：

    郑沛隆 2021-09-13 新建脚本 
    
*/   
/*
    依赖于基础数据表：
    base_d_person_stru_analy
    依赖于上游数据表
    itl_edw_orws_t_emp_edu_resume
    itl_edw_orws_tdm_enumitem
    生成数据表:
    BASE_D_TO_INDEX_DATA
    生成指标列表  
	1	WD010101	网点作业	人员分析	人员结构	原始值	人               
	  维度：年龄、工龄、性别、岗位、学历        

*/  


set timing on

-- 1 alter parallel
alter session force parallel query parallel 4;
alter session force parallel dml parallel 4;
-- alter session force parallel ddl parallel 1;

-- 2.1 create table for exchage and add partition
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${idl_schema}.base_d_to_index_data_${batch_date}_person_stru_analy purge ;
alter table ${idl_schema}.base_d_to_index_data add partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'))(
        subpartition p_${batch_date}_base_d_person_stru_analy values ('BASE_D_PERSON_STRU_ANALY'))
;

alter table ${idl_schema}.base_d_to_index_data modify partition p_${batch_date}
    add subpartition p_${batch_date}_base_d_person_stru_analy values ('BASE_D_PERSON_STRU_ANALY')
;

whenever sqlerror exit sql.sqlcode;
create table ${idl_schema}.base_d_to_index_data_${batch_date}_person_stru_analy
compress ${option_switch} for query high
as
select
    *
from ${idl_schema}.base_d_to_index_data
where 0=1;


-- it is no need to check when this segment SQL was return faied
whenever sqlerror exit sql.sqlcode;
-- 3.1 insert data to tm table
-- WD010101  性别维度
INSERT INTO ${idl_schema}.base_d_to_index_data_${batch_date}_person_stru_analy
    (index_no --VARCHAR2(30)指标编号 
    ,org_no --VARCHAR2(60)指标主体号 
    ,super_org_no --VARCHAR2(6) 上级机构号 
    ,bu_type --VARCHAR2(30)分类     
    ,index_value --NUMBER(38,8)指标值   
    ,source_sys --VARCHAR2(60)来源基础表 
    ,etl_dt --DATE        ETL处理日期 
    ,etl_timestamp --TIMESTAMP(6)ETL处理时间戳 
     )

    SELECT 'WD010101' AS index_no --指标编号 
       ,t1.orgno AS org_no --指标主体号 
       ,t2.super_org_no AS super_org_no -- 上级机构号 
       ,(CASE
            WHEN t1.sex = '1' THEN
             'RYXB001'
            ELSE
             'RYXB002'
        END) AS bu_type --VARCHAR2(30)分类     
       ,COUNT(DISTINCT t1.id) AS index_value --指标值   
       ,'BASE_D_PERSON_STRU_ANALY' AS source_sys --来源基础表 
       ,to_date('${batch_date}'
               ,'yyyymmdd') AS etl_dt -- ETL处理日期
       ,to_timestamp('${batch_timestamp}'
                    ,'yyyy-mm-dd hh24:mi:ss.ff6') AS etl_timestamp -- ETL处理时间戳     
 FROM   base_d_person_stru_analy t1
 INNER  JOIN mcyy_orga_para t2
 ON     t1.orgno = t2.org_no
 AND    t2.org_no <> '800' 
 AND    t2.super_org_no <> '800'
 WHERE  t1.etl_dt = to_date('${batch_date}'
                        ,'yyyymmdd')
 AND    t1.isservice = '1' --是否营运人员 
 AND    t1.status = '1' --人员在职状态 
 GROUP  BY t1.orgno, t2.super_org_no, t1.sex;

COMMIT;

-- WD010101  年龄维度
INSERT INTO ${idl_schema}.base_d_to_index_data_${batch_date}_person_stru_analy
    (index_no --VARCHAR2(30)指标编号 
    ,org_no --VARCHAR2(60)指标主体号 
    ,super_org_no --VARCHAR2(6) 上级机构号 
    ,bu_type --VARCHAR2(30)分类     
    ,index_value --NUMBER(38,8)指标值   
    ,source_sys --VARCHAR2(60)来源基础表 
    ,etl_dt --DATE        ETL处理日期 
    ,etl_timestamp --TIMESTAMP(6)ETL处理时间戳 
     )

    SELECT 'WD010101' AS index_no --指标编号 
       ,t1.orgno AS org_no --指标主体号 
       ,t2.super_org_no AS super_org_no -- 上级机构号 
       ,(CASE 
            WHEN trunc(months_between(SYSDATE
                           ,t1.born_date) / 12)<30 THEN
             'RYNL001'
           WHEN trunc(months_between(SYSDATE
                           ,t1.born_date) / 12)BETWEEN 30 AND 40 THEN
             'RYNL002'
             WHEN trunc(months_between(SYSDATE
                           ,t1.born_date) / 12)BETWEEN 40 AND 45  THEN
             'RYNL003'
             WHEN trunc(months_between(SYSDATE
                           ,t1.born_date) / 12)BETWEEN 45 AND 50 THEN
             'RYNL004'
             WHEN trunc(months_between(SYSDATE
                           ,t1.born_date) / 12)>50 THEN
             'RYNL005'
        END) AS bu_type --VARCHAR2(30)分类     
       ,COUNT(DISTINCT t1.id) AS index_value --指标值   
       ,'BASE_D_PERSON_STRU_ANALY' AS source_sys --来源基础表 
       ,to_date('${batch_date}'
               ,'yyyymmdd') AS etl_dt -- ETL处理日期
       ,to_timestamp('${batch_timestamp}'
                    ,'yyyy-mm-dd hh24:mi:ss.ff6') AS etl_timestamp -- ETL处理时间戳     
 FROM   base_d_person_stru_analy t1
 INNER  JOIN mcyy_orga_para t2
 ON     t1.orgno = t2.org_no
 AND    t2.org_no <> '800' 
 AND    t2.super_org_no <> '800'
 WHERE  t1.etl_dt = to_date('${batch_date}'
                        ,'yyyymmdd')
 AND    t1.isservice = '1' --是否营运人员 
 AND    t1.status = '1' --人员在职状态 
 GROUP  BY t1.orgno, t2.super_org_no, (CASE 
            WHEN trunc(months_between(SYSDATE
                           ,t1.born_date) / 12)<30 THEN
             'RYNL001'
           WHEN trunc(months_between(SYSDATE
                           ,t1.born_date) / 12)BETWEEN 30 AND 40 THEN
             'RYNL002'
             WHEN trunc(months_between(SYSDATE
                           ,t1.born_date) / 12)BETWEEN 40 AND 45  THEN
             'RYNL003'
             WHEN trunc(months_between(SYSDATE
                           ,t1.born_date) / 12)BETWEEN 45 AND 50 THEN
             'RYNL004'
             WHEN trunc(months_between(SYSDATE
                           ,t1.born_date) / 12)>50 THEN
             'RYNL005'
        END);

COMMIT;

-- WD010101  工龄维度
INSERT INTO ${idl_schema}.base_d_to_index_data_${batch_date}_person_stru_analy
    (index_no --VARCHAR2(30)指标编号 
    ,org_no --VARCHAR2(60)指标主体号 
    ,super_org_no --VARCHAR2(6) 上级机构号 
    ,bu_type --VARCHAR2(30)分类     
    ,index_value --NUMBER(38,8)指标值   
    ,source_sys --VARCHAR2(60)来源基础表 
    ,etl_dt --DATE        ETL处理日期 
    ,etl_timestamp --TIMESTAMP(6)ETL处理时间戳 
     )

    SELECT 'WD010101' AS index_no --指标编号 
       ,t1.orgno AS org_no --指标主体号 
       ,t2.super_org_no AS super_org_no -- 上级机构号 
       ,(CASE 
            WHEN trunc(months_between(SYSDATE
                           ,t1.job_date) / 12)<3 THEN
             'RYGL001'
           WHEN trunc(months_between(SYSDATE
                           ,t1.job_date) / 12)BETWEEN 3 AND 5 THEN
             'RYGL002'
             WHEN trunc(months_between(SYSDATE
                           ,t1.job_date) / 12)BETWEEN 5 AND 10  THEN
             'RYGL003'
             WHEN trunc(months_between(SYSDATE
                           ,t1.job_date) / 12)BETWEEN 10 AND 20 THEN
             'RYGL004'
             WHEN trunc(months_between(SYSDATE
                           ,t1.job_date) / 12) >20 THEN
             'RYGL005'
        END) AS bu_type --VARCHAR2(30)分类     
       ,COUNT(DISTINCT t1.id) AS index_value --指标值   
       ,'BASE_D_PERSON_STRU_ANALY' AS source_sys --来源基础表 
       ,to_date('${batch_date}'
               ,'yyyymmdd') AS etl_dt -- ETL处理日期
       ,to_timestamp('${batch_timestamp}'
                    ,'yyyy-mm-dd hh24:mi:ss.ff6') AS etl_timestamp -- ETL处理时间戳     
 FROM   base_d_person_stru_analy t1
 INNER  JOIN mcyy_orga_para t2
 ON     t1.orgno = t2.org_no
 AND    t2.org_no <> '800' 
 AND    t2.super_org_no <> '800'
 WHERE  t1.etl_dt = to_date('${batch_date}'
                        ,'yyyymmdd')
 AND    t1.isservice = '1' --是否营运人员 
 AND    t1.status = '1' --人员在职状态 
 GROUP  BY t1.orgno, t2.super_org_no, (CASE 
            WHEN trunc(months_between(SYSDATE
                           ,t1.job_date) / 12)<3 THEN
             'RYGL001'
           WHEN trunc(months_between(SYSDATE
                           ,t1.job_date) / 12)BETWEEN 3 AND 5 THEN
             'RYGL002'
             WHEN trunc(months_between(SYSDATE
                           ,t1.job_date) / 12)BETWEEN 5 AND 10  THEN
             'RYGL003'
             WHEN trunc(months_between(SYSDATE
                           ,t1.job_date) / 12)BETWEEN 10 AND 20 THEN
             'RYGL004'
             WHEN trunc(months_between(SYSDATE
                           ,t1.job_date) / 12) >20 THEN
             'RYGL005'
        END);

COMMIT;

-- WD010101  岗位维度
INSERT INTO ${idl_schema}.base_d_to_index_data_${batch_date}_person_stru_analy
    (index_no --VARCHAR2(30)指标编号 
    ,org_no --VARCHAR2(60)指标主体号 
    ,super_org_no --VARCHAR2(6) 上级机构号 
    ,bu_type --VARCHAR2(30)分类     
    ,index_value --NUMBER(38,8)指标值   
    ,source_sys --VARCHAR2(60)来源基础表 
    ,etl_dt --DATE        ETL处理日期 
    ,etl_timestamp --TIMESTAMP(6)ETL处理时间戳 
     )

 SELECT 'WD010101' AS index_no --指标编号 
       ,t1.orgno AS org_no --指标主体号 
       ,t2.super_org_no AS super_org_no -- 上级机构号 
       ,fun_code_conv(t3.code
                     ,'WD010101') AS bu_type --VARCHAR2(30)分类     
       ,COUNT(DISTINCT t1.id) AS index_value --指标值   
       ,'BASE_D_PERSON_STRU_ANALY' AS source_sys --来源基础表 
       ,to_date('${batch_date}'
               ,'yyyymmdd') AS etl_dt -- ETL处理日期
       ,to_timestamp('${batch_timestamp}'
                    ,'yyyy-mm-dd hh24:mi:ss.ff6') AS etl_timestamp -- ETL处理时间戳     
 FROM   base_d_person_stru_analy t1
 INNER  JOIN mcyy_orga_para t2
 ON     t1.orgno = t2.org_no
 AND    t2.org_no <> '800'
 AND    t2.super_org_no <> '800'
 LEFT   JOIN itl_edw_orws_tdm_enumitem t3
 ON     t3.enumid = t1.position
 WHERE  t1.etl_dt = to_date('${batch_date}'
                           ,'yyyymmdd')
 AND    t1.isservice = '1' --是否营运人员 
 AND    t1.status = '1' --人员在职状态 
 GROUP  BY t1.orgno
          ,t2.super_org_no
          ,fun_code_conv(t3.code
                        ,'WD010101');

COMMIT;

-- WD010101  学历维度
INSERT INTO ${idl_schema}.base_d_to_index_data_${batch_date}_person_stru_analy
    (index_no --VARCHAR2(30)指标编号 
    ,org_no --VARCHAR2(60)指标主体号 
    ,super_org_no --VARCHAR2(6) 上级机构号 
    ,bu_type --VARCHAR2(30)分类     
    ,index_value --NUMBER(38,8)指标值   
    ,source_sys --VARCHAR2(60)来源基础表 
    ,etl_dt --DATE        ETL处理日期 
    ,etl_timestamp --TIMESTAMP(6)ETL处理时间戳 
     )
 SELECT 'WD010101' AS index_no --指标编号 
      ,t1.orgno AS org_no --指标主体号 
      ,t2.super_org_no AS super_org_no -- 上级机构号 
      ,(CASE t4.name
           WHEN '普通高级中学教育' THEN
            'RYXL001'
           WHEN '中等职业教育' THEN
            'RYXL002'
           WHEN '专科教育' THEN
            'RYXL003'
           WHEN '大学本科' THEN
            'RYXL004'
           WHEN '研究生教育' THEN
            'RYXL005'
           WHEN '博士' THEN
            'RYXL006'
       END) AS bu_type --VARCHAR2(30)分类     
      ,COUNT(DISTINCT t1.id) AS index_value --指标值   
      ,'BASE_D_PERSON_STRU_ANALY' AS source_sys --来源基础表 
      ,to_date('${batch_date}'
              ,'yyyymmdd') AS etl_dt -- ETL处理日期
      ,to_timestamp('${batch_timestamp}'
                   ,'yyyy-mm-dd hh24:mi:ss.ff6') AS etl_timestamp -- ETL处理时间戳     
FROM   base_d_person_stru_analy t1
INNER  JOIN mcyy_orga_para t2
ON     t1.orgno = t2.org_no
AND    t2.org_no <> '800'
AND    t2.super_org_no <> '800'
LEFT   JOIN (SELECT emp_info, MAX(academic) AS academic_max
             FROM   itl_edw_orws_t_emp_edu_resume
             GROUP  BY emp_info) t3
ON     t3.emp_info = t1.id
LEFT   JOIN itl_edw_orws_tdm_enumitem t4
ON     t4.enumid = t3.academic_max
WHERE  t1.etl_dt = to_date('${batch_date}'
                          ,'yyyymmdd')
AND    t1.isservice = '1' --是否营运人员 
AND    t1.status = '1' --人员在职状态 
GROUP  BY t1.orgno
         ,t2.super_org_no
         ,(CASE t4.name
           WHEN '普通高级中学教育' THEN
            'RYXL001'
           WHEN '中等职业教育' THEN
            'RYXL002'
           WHEN '专科教育' THEN
            'RYXL003'
           WHEN '大学本科' THEN
            'RYXL004'
           WHEN '研究生教育' THEN
            'RYXL005'
           WHEN '博士' THEN
            'RYXL006'
       END);

COMMIT;
	  
-- 3.2 truncate target table batch_date partition
alter table ${idl_schema}.base_d_to_index_data truncate subpartition p_${batch_date}_base_d_person_stru_analy reuse storage;


-- 3.3 exchage tm table and target table
alter table ${idl_schema}.base_d_to_index_data exchange subpartition p_${batch_date}_base_d_person_stru_analy with table ${idl_schema}.base_d_to_index_data_${batch_date}_person_stru_analy;

-- 4.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${idl_schema}.base_d_to_index_data to ${idl_schema};

-- 4.2 drop tm table
drop table ${idl_schema}.base_d_to_index_data_${batch_date}_person_stru_analy purge;

-- 5 gater table status
exec dbms_stats.gather_table_stats(ownname => '${idl_schema}',tabname => 'base_d_to_index_data', partname => 'p_${batch_date}_base_d_person_stru_analy', granularity => 'SUBPARTITION', degree => 8, cascade => true);

-- 6
whenever sqlerror continue none;

alter table ${idl_schema}.mcyy_human_risk truncate subpartition p_${batch_date}_person_stru_analy;

alter table ${idl_schema}.mcyy_human_risk add partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'))(
                                              subpartition p_${batch_date}_person_stru_analy values ('BASE_D_PERSON_STRU_ANALY')
                                              )
;
alter table ${idl_schema}.mcyy_human_risk modify partition p_${batch_date} 
                                             add subpartition p_${batch_date}_person_stru_analy values ('BASE_D_PERSON_STRU_ANALY')
;

whenever sqlerror exit sql.sqlcode;


call pkg_mcyy_ind_share_intfc.prc_get_sorc_sys_data('BASE_D_PERSON_STRU_ANALY',${batch_date});


whenever sqlerror exit sql.sqlcode;

exec dbms_stats.gather_table_stats(ownname => '${idl_schema}',tabname => 'mcyy_human_risk',partname => 'p_${batch_date}_person_stru_analy', granularity => 'SUBPARTITION', degree => 8, cascade => true);

