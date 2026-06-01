/*
Purpose:    指标应用层-ATM交易情况，清空目标表当天分区数据，把当天数据与目标表进行分区交换。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd idl_mcyy_atm_bus_situ_dtl2index_data
CreateDate: 20210705
修改记录：

    郑沛隆 2021-07-05 新建脚本 
    
*/   
/*
    依赖于基础数据表：
    BASE_D_ATM_BUS_SITU_DTL
    生成数据表:
    BASE_D_TO_INDEX_DATA
    生成指标列表  
    1	WD041111		ATM/CRS总业务量笔数		笔	
    2	WD041112		ATM/CRS总业务量金额		元	
    3	WD041113		ATM/CRS存款业务量笔数	笔	
    4	WD041114		ATM/CRS存款业务量金额	元	 
    5	WD041115		ATM/CRS取款区域业务量笔数		笔	
    6	WD041116		ATM/CRS取款区域业务量金额		元	
    7	WD041117		ATM/CRS取款账户业务量笔数		笔	
    8	WD041118		ATM/CRS取款账户业务量金额		元	
    9	WD041119		ATM/CRS取款类型业务量笔数		笔	
   10 WD041120		ATM/CRS取款类型业务量金额		元	
   11	WD041121 	  ATM/CRS转账业务量笔数		笔	
   12	WD041122    ATM/CRS转账业务量金额		元	
	 13 WD041029    受理客户量统计          户
*/  


set timing on

-- 1 alter parallel
alter session force parallel query parallel 4;
alter session force parallel dml parallel 4;
-- alter session force parallel ddl parallel 1;

-- 2.1 create table for exchage and add partition
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${idl_schema}.base_d_to_index_data_${batch_date}_atm_bus_situ_dtl_tm purge ;

alter table ${idl_schema}.base_d_to_index_data add partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'))(
        subpartition p_${batch_date}_atm_bus_situ_dtl values ('BASE_D_ATM_BUS_SITU_DTL'))
;

alter table ${idl_schema}.base_d_to_index_data modify partition p_${batch_date}
    add subpartition p_${batch_date}_atm_bus_situ_dtl values ('BASE_D_ATM_BUS_SITU_DTL')
;

whenever sqlerror exit sql.sqlcode;
create table ${idl_schema}.base_d_to_index_data_${batch_date}_atm_bus_situ_dtl_tm
compress ${option_switch} for query high
as
select
    *
from ${idl_schema}.base_d_to_index_data
where 0=1;


-- it is no need to check when this segment SQL was return faied
whenever sqlerror exit sql.sqlcode;
-- 3.1 insert data to tm table
-- WD041111		ATM/CRS总业务量笔数 区分类型
INSERT INTO ${idl_schema}.base_d_to_index_data_${batch_date}_atm_bus_situ_dtl_tm
    (index_no --VARCHAR2(30)指标编号 
    ,org_no --VARCHAR2(60)指标主体号 
    ,super_org_no --VARCHAR2(6) 上级机构号 
    ,bu_type --VARCHAR2(30)分类     
    ,index_value --NUMBER(38,8)指标值   
    ,source_sys --VARCHAR2(60)来源基础表 
    ,etl_dt --DATE        ETL处理日期 
    ,etl_timestamp --TIMESTAMP(6)ETL处理时间戳 
     )

    SELECT 'WD041111' AS index_no --指标编号 
          ,t1.proc_termn_id AS org_no --指标主体号 
          ,t1.tran_org_cd AS super_org_no -- 上级机构号 
          ,fun_code_conv(t1.tran_type
                        ,'WD041111') AS bu_type --分类
          ,COUNT(1) AS index_value --指标值   
          ,'BASE_D_ATM_BUS_SITU_DTL' AS source_sys --来源基础表 
          ,to_date('${batch_date}'
                  ,'yyyymmdd') AS etl_dt -- ETL处理日期
          ,to_timestamp('${batch_timestamp}'
                       ,'yyyy-mm-dd hh24:mi:ss.ff6') AS etl_timestamp -- ETL处理时间戳     
    FROM   base_d_atm_bus_situ_dtl t1
    LEFT   JOIN mcyy_orga_para t2
    ON     t2.org_no = t1.tran_org_cd
    WHERE  t1.etl_dt = to_date('${batch_date}'
                              ,'yyyymmdd')
    GROUP  BY t1.tran_org_cd
             ,t1.proc_termn_id
             ,fun_code_conv(t1.tran_type
                           ,'WD041111');

COMMIT;

-- WD041112		ATM/CRS总业务量金额 区分类型
INSERT INTO ${idl_schema}.base_d_to_index_data_${batch_date}_atm_bus_situ_dtl_tm
    (index_no --VARCHAR2(30)指标编号 
    ,org_no --VARCHAR2(60)指标主体号 
    ,super_org_no --VARCHAR2(6) 上级机构号 
    ,bu_type --VARCHAR2(30)分类     
    ,index_value --NUMBER(38,8)指标值   
    ,source_sys --VARCHAR2(60)来源基础表 
    ,etl_dt --DATE        ETL处理日期 
    ,etl_timestamp --TIMESTAMP(6)ETL处理时间戳 
     )

    SELECT 'WD041112' AS index_no --指标编号 
          ,t1.proc_termn_id AS org_no --指标主体号 
          ,t1.tran_org_cd AS super_org_no -- 上级机构号 
          ,fun_code_conv(t1.tran_type
                        ,'WD041112') AS bu_type --分类
          ,sum(t1.tran_amt) AS index_value --指标值   
          ,'BASE_D_ATM_BUS_SITU_DTL' AS source_sys --来源基础表 
          ,to_date('${batch_date}'
                  ,'yyyymmdd') AS etl_dt -- ETL处理日期
          ,to_timestamp('${batch_timestamp}'
                       ,'yyyy-mm-dd hh24:mi:ss.ff6') AS etl_timestamp -- ETL处理时间戳     
    FROM   base_d_atm_bus_situ_dtl t1
    LEFT   JOIN mcyy_orga_para t2
    ON     t2.org_no = t1.tran_org_cd
    WHERE  t1.etl_dt = to_date('${batch_date}'
                              ,'yyyymmdd')
    GROUP  BY t1.tran_org_cd
             ,t1.proc_termn_id
             ,fun_code_conv(t1.tran_type
                           ,'WD041112');

COMMIT;

-- WD041113		ATM/CRS存款业务量笔数 区分区域
INSERT INTO ${idl_schema}.base_d_to_index_data_${batch_date}_atm_bus_situ_dtl_tm
    (index_no --VARCHAR2(30)指标编号 
    ,org_no --VARCHAR2(60)指标主体号 
    ,super_org_no --VARCHAR2(6) 上级机构号 
    ,bu_type --VARCHAR2(30)分类     
    ,index_value --NUMBER(38,8)指标值   
    ,source_sys --VARCHAR2(60)来源基础表 
    ,etl_dt --DATE        ETL处理日期 
    ,etl_timestamp --TIMESTAMP(6)ETL处理时间戳 
     )

    SELECT 'WD041113' AS index_no --指标编号 
          ,t1.proc_termn_id AS org_no --指标主体号 
          ,t1.tran_org_cd AS super_org_no -- 上级机构号 
          ,fun_code_conv(t1.city_wide_remote_idf
                        ,'WD041113') AS bu_type --分类
          ,COUNT(1)  AS index_value --指标值   
          ,'BASE_D_ATM_BUS_SITU_DTL' AS source_sys --来源基础表 
          ,to_date('${batch_date}'
                  ,'yyyymmdd') AS etl_dt -- ETL处理日期
          ,to_timestamp('${batch_timestamp}'
                       ,'yyyy-mm-dd hh24:mi:ss.ff6') AS etl_timestamp -- ETL处理时间戳     
    FROM   base_d_atm_bus_situ_dtl t1
    LEFT   JOIN mcyy_orga_para t2
    ON     t2.org_no = t1.tran_org_cd
    WHERE  t1.etl_dt = to_date('${batch_date}'
                              ,'yyyymmdd')
    AND    t1.dim_class_name ='存款'
    GROUP  BY t1.tran_org_cd
             ,t1.proc_termn_id
             ,fun_code_conv(t1.city_wide_remote_idf
                        ,'WD041113');

COMMIT;


--WD041114		ATM/CRS存款业务量金额	区分区域
  
INSERT INTO ${idl_schema}.base_d_to_index_data_${batch_date}_atm_bus_situ_dtl_tm
    (index_no --VARCHAR2(30)指标编号 
    ,org_no --VARCHAR2(60)指标主体号 
    ,super_org_no --VARCHAR2(6) 上级机构号 
    ,bu_type --VARCHAR2(30)分类     
    ,index_value --NUMBER(38,8)指标值   
    ,source_sys --VARCHAR2(60)来源基础表 
    ,etl_dt --DATE        ETL处理日期 
    ,etl_timestamp --TIMESTAMP(6)ETL处理时间戳 
     )

    SELECT 'WD041114' AS index_no --指标编号 
          ,t1.proc_termn_id AS org_no --指标主体号 
          ,t1.tran_org_cd AS super_org_no -- 上级机构号 
          ,fun_code_conv(t1.city_wide_remote_idf
                        ,'WD041114') AS bu_type --分类
          ,sum(t1.tran_amt) AS index_value --指标值   
          ,'BASE_D_ATM_BUS_SITU_DTL' AS source_sys --来源基础表 
          ,to_date('${batch_date}'
                  ,'yyyymmdd') AS etl_dt -- ETL处理日期
          ,to_timestamp('${batch_timestamp}'
                       ,'yyyy-mm-dd hh24:mi:ss.ff6') AS etl_timestamp -- ETL处理时间戳     
    FROM   base_d_atm_bus_situ_dtl t1
    LEFT   JOIN mcyy_orga_para t2
    ON     t2.org_no = t1.tran_org_cd
    WHERE  t1.etl_dt = to_date('${batch_date}'
                              ,'yyyymmdd')
    AND    t1.dim_class_name ='存款'
    GROUP  BY t1.tran_org_cd
             ,t1.proc_termn_id
             ,fun_code_conv(t1.city_wide_remote_idf
                        ,'WD041114');

COMMIT;

--WD041115		ATM/CRS取款区域业务量笔数	区分区域

INSERT INTO ${idl_schema}.base_d_to_index_data_${batch_date}_atm_bus_situ_dtl_tm
    (index_no --VARCHAR2(30)指标编号 
    ,org_no --VARCHAR2(60)指标主体号 
    ,super_org_no --VARCHAR2(6) 上级机构号 
    ,bu_type --VARCHAR2(30)分类     
    ,index_value --NUMBER(38,8)指标值   
    ,source_sys --VARCHAR2(60)来源基础表 
    ,etl_dt --DATE        ETL处理日期 
    ,etl_timestamp --TIMESTAMP(6)ETL处理时间戳 
     )

    SELECT 'WD041115' AS index_no --指标编号 
          ,t1.proc_termn_id AS org_no --指标主体号 
          ,t1.tran_org_cd AS super_org_no -- 上级机构号 
          ,fun_code_conv(t1.city_wide_remote_idf
                        ,'WD041115') AS bu_type --分类
          ,COUNT(1)  AS index_value --指标值   
          ,'BASE_D_ATM_BUS_SITU_DTL' AS source_sys --来源基础表 
          ,to_date('${batch_date}'
                  ,'yyyymmdd') AS etl_dt -- ETL处理日期
          ,to_timestamp('${batch_timestamp}'
                       ,'yyyy-mm-dd hh24:mi:ss.ff6') AS etl_timestamp -- ETL处理时间戳     
    FROM   base_d_atm_bus_situ_dtl t1
    LEFT   JOIN mcyy_orga_para t2
    ON     t2.org_no = t1.tran_org_cd
    WHERE  t1.etl_dt = to_date('${batch_date}'
                              ,'yyyymmdd')
    AND    t1.dim_class_name ='取款'
    GROUP  BY t1.tran_org_cd
             ,t1.proc_termn_id
             ,fun_code_conv(t1.city_wide_remote_idf
                        ,'WD041115');

COMMIT;
--WD041116		ATM/CRS取款区域业务量金额	区分区域

INSERT INTO ${idl_schema}.base_d_to_index_data_${batch_date}_atm_bus_situ_dtl_tm
    (index_no --VARCHAR2(30)指标编号 
    ,org_no --VARCHAR2(60)指标主体号 
    ,super_org_no --VARCHAR2(6) 上级机构号 
    ,bu_type --VARCHAR2(30)分类     
    ,index_value --NUMBER(38,8)指标值   
    ,source_sys --VARCHAR2(60)来源基础表 
    ,etl_dt --DATE        ETL处理日期 
    ,etl_timestamp --TIMESTAMP(6)ETL处理时间戳 
     )

    SELECT 'WD041116' AS index_no --指标编号 
          ,t1.proc_termn_id AS org_no --指标主体号 
          ,t1.tran_org_cd AS super_org_no -- 上级机构号 
          ,fun_code_conv(t1.city_wide_remote_idf
                        ,'WD041116') AS bu_type --分类
          ,sum(t1.tran_amt) AS index_value --指标值   
          ,'BASE_D_ATM_BUS_SITU_DTL' AS source_sys --来源基础表 
          ,to_date('${batch_date}'
                  ,'yyyymmdd') AS etl_dt -- ETL处理日期
          ,to_timestamp('${batch_timestamp}'
                       ,'yyyy-mm-dd hh24:mi:ss.ff6') AS etl_timestamp -- ETL处理时间戳     
    FROM   base_d_atm_bus_situ_dtl t1
    LEFT   JOIN mcyy_orga_para t2
    ON     t2.org_no = t1.tran_org_cd
    WHERE  t1.etl_dt = to_date('${batch_date}'
                              ,'yyyymmdd')
    AND    t1.dim_class_name ='取款'
    GROUP  BY t1.tran_org_cd
             ,t1.proc_termn_id
             ,fun_code_conv(t1.city_wide_remote_idf
                        ,'WD041116');

COMMIT;
--WD041121 	  ATM/CRS转账业务量笔数		区分区域

INSERT INTO ${idl_schema}.base_d_to_index_data_${batch_date}_atm_bus_situ_dtl_tm
    (index_no --VARCHAR2(30)指标编号 
    ,org_no --VARCHAR2(60)指标主体号 
    ,super_org_no --VARCHAR2(6) 上级机构号 
    ,bu_type --VARCHAR2(30)分类     
    ,index_value --NUMBER(38,8)指标值   
    ,source_sys --VARCHAR2(60)来源基础表 
    ,etl_dt --DATE        ETL处理日期 
    ,etl_timestamp --TIMESTAMP(6)ETL处理时间戳 
     )

    SELECT 'WD041121' AS index_no --指标编号 
          ,t1.proc_termn_id AS org_no --指标主体号 
          ,t1.tran_org_cd AS super_org_no -- 上级机构号 
          ,fun_code_conv(t1.city_wide_remote_idf
                        ,'WD041121') AS bu_type --分类
          ,COUNT(1)  AS index_value --指标值   
          ,'BASE_D_ATM_BUS_SITU_DTL' AS source_sys --来源基础表 
          ,to_date('${batch_date}'
                  ,'yyyymmdd') AS etl_dt -- ETL处理日期
          ,to_timestamp('${batch_timestamp}'
                       ,'yyyy-mm-dd hh24:mi:ss.ff6') AS etl_timestamp -- ETL处理时间戳     
    FROM   base_d_atm_bus_situ_dtl t1
    LEFT   JOIN mcyy_orga_para t2
    ON     t2.org_no = t1.tran_org_cd
    WHERE  t1.etl_dt = to_date('${batch_date}'
                              ,'yyyymmdd')
    AND    t1.dim_class_name ='转账'
    GROUP  BY t1.tran_org_cd
             ,t1.proc_termn_id
             ,fun_code_conv(t1.city_wide_remote_idf
                        ,'WD041121');

COMMIT;

--WD041122    ATM/CRS转账业务量金额		区分区域

INSERT INTO ${idl_schema}.base_d_to_index_data_${batch_date}_atm_bus_situ_dtl_tm
    (index_no --VARCHAR2(30)指标编号 
    ,org_no --VARCHAR2(60)指标主体号 
    ,super_org_no --VARCHAR2(6) 上级机构号 
    ,bu_type --VARCHAR2(30)分类     
    ,index_value --NUMBER(38,8)指标值   
    ,source_sys --VARCHAR2(60)来源基础表 
    ,etl_dt --DATE        ETL处理日期 
    ,etl_timestamp --TIMESTAMP(6)ETL处理时间戳 
     )

    SELECT 'WD041122' AS index_no --指标编号 
          ,t1.proc_termn_id AS org_no --指标主体号 
          ,t1.tran_org_cd AS super_org_no -- 上级机构号 
          ,fun_code_conv(t1.city_wide_remote_idf
                        ,'WD041122') AS bu_type --分类
          ,sum(t1.tran_amt) AS index_value --指标值   
          ,'BASE_D_ATM_BUS_SITU_DTL' AS source_sys --来源基础表 
          ,to_date('${batch_date}'
                  ,'yyyymmdd') AS etl_dt -- ETL处理日期
          ,to_timestamp('${batch_timestamp}'
                       ,'yyyy-mm-dd hh24:mi:ss.ff6') AS etl_timestamp -- ETL处理时间戳     
    FROM   base_d_atm_bus_situ_dtl t1
    LEFT   JOIN mcyy_orga_para t2
    ON     t2.org_no = t1.tran_org_cd
    WHERE  t1.etl_dt = to_date('${batch_date}'
                              ,'yyyymmdd')
    AND    t1.dim_class_name ='转账'
    GROUP  BY t1.tran_org_cd
             ,t1.proc_termn_id
             ,fun_code_conv(t1.city_wide_remote_idf
                        ,'WD041122');

COMMIT;

--WD041117		ATM/CRS取款账户业务量笔数	区分账户	

INSERT INTO ${idl_schema}.base_d_to_index_data_${batch_date}_atm_bus_situ_dtl_tm
    (index_no --VARCHAR2(30)指标编号 
    ,org_no --VARCHAR2(60)指标主体号 
    ,super_org_no --VARCHAR2(6) 上级机构号 
    ,bu_type --VARCHAR2(30)分类     
    ,index_value --NUMBER(38,8)指标值   
    ,source_sys --VARCHAR2(60)来源基础表 
    ,etl_dt --DATE        ETL处理日期 
    ,etl_timestamp --TIMESTAMP(6)ETL处理时间戳 
     )

    SELECT 'WD041117' AS index_no --指标编号 
          ,t1.proc_termn_id AS org_no --指标主体号 
          ,t1.tran_org_cd AS super_org_no -- 上级机构号
		  ,(case when t1.cross_bank_idf='是' then 'ATM_QK_ZH_LX002' else 'ATM_QK_ZH_LX001' end) AS bu_type --分类
          ,COUNT(1)  AS index_value --指标值   
          ,'BASE_D_ATM_BUS_SITU_DTL' AS source_sys --来源基础表 
          ,to_date('${batch_date}'
                  ,'yyyymmdd') AS etl_dt -- ETL处理日期
          ,to_timestamp('${batch_timestamp}'
                       ,'yyyy-mm-dd hh24:mi:ss.ff6') AS etl_timestamp -- ETL处理时间戳     
    FROM   base_d_atm_bus_situ_dtl t1
    LEFT   JOIN mcyy_orga_para t2
    ON     t2.org_no = t1.tran_org_cd
    WHERE  t1.etl_dt = to_date('${batch_date}'
                              ,'yyyymmdd')
    AND    t1.dim_class_name ='取款'
    GROUP  BY t1.tran_org_cd
             ,t1.proc_termn_id
             ,(case when t1.cross_bank_idf='是' then 'ATM_QK_ZH_LX002' else 'ATM_QK_ZH_LX001' end);

COMMIT;

--WD041118		ATM/CRS取款账户业务量金额	区分账户	

INSERT INTO ${idl_schema}.base_d_to_index_data_${batch_date}_atm_bus_situ_dtl_tm
    (index_no --VARCHAR2(30)指标编号 
    ,org_no --VARCHAR2(60)指标主体号 
    ,super_org_no --VARCHAR2(6) 上级机构号 
    ,bu_type --VARCHAR2(30)分类     
    ,index_value --NUMBER(38,8)指标值   
    ,source_sys --VARCHAR2(60)来源基础表 
    ,etl_dt --DATE        ETL处理日期 
    ,etl_timestamp --TIMESTAMP(6)ETL处理时间戳 
     )

    SELECT 'WD041118' AS index_no --指标编号 
          ,t1.proc_termn_id AS org_no --指标主体号 
          ,t1.tran_org_cd AS super_org_no -- 上级机构号
		  ,(case when t1.cross_bank_idf='是' then 'ATM_QK_ZH_LX002' else 'ATM_QK_ZH_LX001' end) AS bu_type --分类
          ,sum(t1.tran_amt)  AS index_value --指标值   
          ,'BASE_D_ATM_BUS_SITU_DTL' AS source_sys --来源基础表 
          ,to_date('${batch_date}'
                  ,'yyyymmdd') AS etl_dt -- ETL处理日期
          ,to_timestamp('${batch_timestamp}'
                       ,'yyyy-mm-dd hh24:mi:ss.ff6') AS etl_timestamp -- ETL处理时间戳     
    FROM   base_d_atm_bus_situ_dtl t1
    LEFT   JOIN mcyy_orga_para t2
    ON     t2.org_no = t1.tran_org_cd
    WHERE  t1.etl_dt = to_date('${batch_date}'
                              ,'yyyymmdd')
    AND    t1.dim_class_name ='取款'
    GROUP  BY t1.tran_org_cd
             ,t1.proc_termn_id
             ,(case when t1.cross_bank_idf='是' then 'ATM_QK_ZH_LX002' else 'ATM_QK_ZH_LX001' end);

COMMIT;

--WD041119		ATM/CRS取款类型业务量笔数	区分类型

INSERT INTO ${idl_schema}.base_d_to_index_data_${batch_date}_atm_bus_situ_dtl_tm
    (index_no --VARCHAR2(30)指标编号 
    ,org_no --VARCHAR2(60)指标主体号 
    ,super_org_no --VARCHAR2(6) 上级机构号 
    ,bu_type --VARCHAR2(30)分类     
    ,index_value --NUMBER(38,8)指标值   
    ,source_sys --VARCHAR2(60)来源基础表 
    ,etl_dt --DATE        ETL处理日期 
    ,etl_timestamp --TIMESTAMP(6)ETL处理时间戳 
     )

    SELECT 'WD041119' AS index_no --指标编号 
          ,t1.proc_termn_id AS org_no --指标主体号 
          ,t1.tran_org_cd AS super_org_no -- 上级机构号 
          ,(case when t1.tran_type like'%二维码%' then 'ATM_QK_JY_LX001' else 'ATM_QK_JY_LX002' end) AS bu_type --分类
          ,COUNT(1)  AS index_value --指标值   
          ,'BASE_D_ATM_BUS_SITU_DTL' AS source_sys --来源基础表 
          ,to_date('${batch_date}'
                  ,'yyyymmdd') AS etl_dt -- ETL处理日期
          ,to_timestamp('${batch_timestamp}'
                       ,'yyyy-mm-dd hh24:mi:ss.ff6') AS etl_timestamp -- ETL处理时间戳     
    FROM   base_d_atm_bus_situ_dtl t1
    LEFT   JOIN mcyy_orga_para t2
    ON     t2.org_no = t1.tran_org_cd
    WHERE  t1.etl_dt = to_date('${batch_date}'
                              ,'yyyymmdd')
    AND    t1.dim_class_name ='取款'
    GROUP  BY t1.tran_org_cd
             ,t1.proc_termn_id
             ,(case when t1.tran_type like'%二维码%' then 'ATM_QK_JY_LX001' else 'ATM_QK_JY_LX002' end);

COMMIT;

--WD041120		ATM/CRS取款类型业务量金额	区分类型	

INSERT INTO ${idl_schema}.base_d_to_index_data_${batch_date}_atm_bus_situ_dtl_tm
    (index_no --VARCHAR2(30)指标编号 
    ,org_no --VARCHAR2(60)指标主体号 
    ,super_org_no --VARCHAR2(6) 上级机构号 
    ,bu_type --VARCHAR2(30)分类     
    ,index_value --NUMBER(38,8)指标值   
    ,source_sys --VARCHAR2(60)来源基础表 
    ,etl_dt --DATE        ETL处理日期 
    ,etl_timestamp --TIMESTAMP(6)ETL处理时间戳 
     )

    SELECT 'WD041120' AS index_no --指标编号 
          ,t1.proc_termn_id AS org_no --指标主体号 
          ,t1.tran_org_cd AS super_org_no -- 上级机构号 
          ,(case when t1.tran_type like'%二维码%' then 'ATM_QK_JY_LX001' else 'ATM_QK_JY_LX002' end) AS bu_type --分类
          ,sum(t1.tran_amt)  AS index_value --指标值   
          ,'BASE_D_ATM_BUS_SITU_DTL' AS source_sys --来源基础表 
          ,to_date('${batch_date}'
                  ,'yyyymmdd') AS etl_dt -- ETL处理日期
          ,to_timestamp('${batch_timestamp}'
                       ,'yyyy-mm-dd hh24:mi:ss.ff6') AS etl_timestamp -- ETL处理时间戳     
    FROM   base_d_atm_bus_situ_dtl t1
    LEFT   JOIN mcyy_orga_para t2
    ON     t2.org_no = t1.tran_org_cd
    WHERE  t1.etl_dt = to_date('${batch_date}'
                              ,'yyyymmdd')
    AND    t1.dim_class_name ='取款'
    GROUP  BY t1.tran_org_cd
             ,t1.proc_termn_id
             ,(case when t1.tran_type like'%二维码%' then 'ATM_QK_JY_LX001' else 'ATM_QK_JY_LX002' end);

COMMIT;

--WD041029    受理客户量统计          

INSERT INTO ${idl_schema}.base_d_to_index_data_${batch_date}_atm_bus_situ_dtl_tm
    (index_no --VARCHAR2(30)指标编号 
    ,org_no --VARCHAR2(60)指标主体号 
    ,super_org_no --VARCHAR2(6) 上级机构号 
    ,bu_type --VARCHAR2(30)分类     
    ,index_value --NUMBER(38,8)指标值   
    ,source_sys --VARCHAR2(60)来源基础表 
    ,etl_dt --DATE        ETL处理日期 
    ,etl_timestamp --TIMESTAMP(6)ETL处理时间戳 
     )
    SELECT 'WD041029' AS index_no --指标编号 
      ,t1.proc_termn_id AS org_no --指标主体号 
      ,t1.tran_org_cd AS super_org_no -- 上级机构号 
      ,NULL AS bu_type --分类
      ,COUNT(DISTINCT MAIN_ACCT_ID) AS index_value --指标值   
      ,'BASE_D_ATM_BUS_SITU_DTL' AS source_sys --来源基础表 
      ,to_date('${batch_date}'
              ,'yyyymmdd') AS etl_dt -- ETL处理日期
      ,to_timestamp('${batch_timestamp}'
                   ,'yyyy-mm-dd hh24:mi:ss.ff6') AS etl_timestamp -- ETL处理时间戳     
FROM   base_d_atm_bus_situ_dtl t1
WHERE  t1.etl_dt = to_date('${batch_date}'
                          ,'yyyymmdd')
GROUP  BY t1.proc_termn_id, t1.tran_org_cd;

COMMIT;


-- 3.2 truncate target table batch_date partition
alter table ${idl_schema}.base_d_to_index_data truncate subpartition p_${batch_date}_atm_bus_situ_dtl reuse storage;


-- 3.3 exchage tm table and target table
alter table ${idl_schema}.base_d_to_index_data exchange subpartition p_${batch_date}_atm_bus_situ_dtl with table ${idl_schema}.base_d_to_index_data_${batch_date}_atm_bus_situ_dtl_tm;

-- 4.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${idl_schema}.base_d_to_index_data to ${idl_schema};

-- 4.2 drop tm table
drop table ${idl_schema}.base_d_to_index_data_${batch_date}_atm_bus_situ_dtl_tm purge;

-- 5 gater table status
exec dbms_stats.gather_table_stats(ownname => '${idl_schema}',tabname => 'base_d_to_index_data', partname => 'p_${batch_date}_atm_bus_situ_dtl', granularity => 'SUBPARTITION', degree => 8, cascade => true);

-- 6 


whenever sqlerror continue none;

alter table ${idl_schema}.mcyy_bu_analysis truncate subpartition p_${batch_date}_atm_bus_situ_dtl;

alter table ${idl_schema}.mcyy_bu_analysis add partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'))(
                                              subpartition p_${batch_date}_atm_bus_situ_dtl values ('BASE_D_ATM_BUS_SITU_DTL')
                                              )
;
alter table ${idl_schema}.mcyy_bu_analysis modify partition p_${batch_date} 
                                             add subpartition p_${batch_date}_atm_bus_situ_dtl values ('BASE_D_ATM_BUS_SITU_DTL')
;

whenever sqlerror exit sql.sqlcode;

call pkg_mcyy_ind_share_intfc.prc_get_sorc_sys_data('BASE_D_ATM_BUS_SITU_DTL',${batch_date});

whenever sqlerror exit sql.sqlcode;

exec dbms_stats.gather_table_stats(ownname => '${idl_schema}',tabname => 'mcyy_bu_analysis',partname => 'p_${batch_date}_atm_bus_situ_dtl', granularity => 'SUBPARTITION', degree => 8, cascade => true);

