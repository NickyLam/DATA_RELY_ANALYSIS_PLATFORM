/*
Purpose:    IDL-绩效考核专区指标
Creater:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd idl_mc_index_fact
CreateDate: None
FileType:   DML
Logs:
    表英文名： mc_index_fact
    表中文名： 绩效考核专区指标
    创建日期： None
    主键字段： 数据日期
    归属层次： IDL
    归属主题： None
    分区粒度： 
    分析人员： None
    时间粒度： 日
    保留周期： 永久
    描述信息： 指标区分规模类和客户及其他、盈利类规模类和客户及其他的数据是根据度量多条展示，盈利类的当月值和当年值是一条数据展示。
    更新记录:
        2025-05-10    郑沛隆    新建脚本    
        2025-09-02    郑沛隆    修改指标所属机构为考核机构    
        2025-09-05    郑沛隆    绩效贷款汇总表和明细表关联指标定义表时，将产品中文名称调整为产品编号    
*/


--设置参数
set timing on
-- 0.1 alter parallel
alter session force parallel query parallel 8;
alter session force parallel dml parallel 8;
-- 1.1 create table for exchage
whenever sqlerror continue none;
alter table ${idl_schema}.mc_index_fact add partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'))(subpartition p_${batch_date}_JXKH values ('JXKH'));
alter table ${idl_schema}.mc_index_fact modify partition p_${batch_date} add subpartition p_${batch_date}_JXKH values ('JXKH');
alter table ${idl_schema}.mc_index_fact truncate subpartition p_${batch_date}_JXKH;

whenever sqlerror exit sql.sqlcode; 

/*==============第1组==============*/

--指标结果表02:绩效报表产品筛选汇总-贷款
whenever sqlerror continue none;
drop table ${idl_schema}.tmp_mc_index_fact_jxkh_ind_result_2 purge;
whenever sqlerror exit sql.sqlcode;
create table ${idl_schema}.tmp_mc_index_fact_jxkh_ind_result_2 (
    index_no_mcs varchar2(60)                                     --指标编号_管驾
    ,index_name_mcs varchar2(500) --指标名称_管驾
    ,org_no varchar2(60) --机构编号
    ,org_name varchar2(500) --机构名称
    ,index_value number(38,8) --指标值
    -- 5
    ,measure_no varchar2(150) --度量编号
    ,index_measure varchar2(500) --度量名称
    ,curr_no varchar2(10) --币种代码
    ,curr_name varchar2(500) --币种名称
    ,etl_dt date --ETL处理日期
    -- 10
    ,etl_timestamp timestamp(6) --ETL处理时间戳
)
 ;

insert into ${idl_schema}.tmp_mc_index_fact_jxkh_ind_result_2(
    index_no_mcs                                                 --指标编号_管驾
    ,index_name_mcs                                              --指标名称_管驾
    ,org_no                                                      --机构编号
    ,org_name                                                    --机构名称
    ,index_value                                                 --指标值
    -- 5
    ,measure_no                                                  --度量编号
    ,index_measure                                               --度量名称
    ,curr_no                                                     --币种代码
    ,curr_name                                                   --币种名称
    ,etl_dt                                                      --ETL处理日期
    -- 10
    ,etl_timestamp                                               --ETL处理时间戳
)
select
    t1.index_no_mcs as index_no_mcs                              --None
    ,t1.index_name_mcs as index_name_mcs                         --None
    ,t2.ssjgh as org_no                                          --None
    ,t3.org_abbr as org_name                                     --None
    ,sum(nvl(t2.index_value,0)) as index_value                   --None
    -- 5
    ,t2.measure_no as measure_no                                 --None
    ,decode(t2.measure_no,'001','当期值','002','月日均','004','年日均') as index_measure --None
    ,decode(t2.bz,'01','CNY','0A','BWB','FF','BWB') as curr_no   --None
    ,decode(t2.bz,'01','人民币','0A','本外币合计','FF','本外币合计') as curr_name --None
    ,to_date('${batch_date}','yyyymmdd') as etl_dt               --None
    -- 10
    ,TO_TIMESTAMP('${batch_timestamp}','yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp --None
 from itl_edw_pams_jxbb_dkftphz unpivot (
  index_value for measure_no in (
    ye as  '001',
    yrj as '002',
    nrj as '004'
  )
) t2 --None 
INNER JOIN mtl_cmm_intnal_org_info t3 --None 
 on t2.ssjgh = t3.org_id
   and t3.etl_dt = to_date('${batch_date}','yyyymmdd')
INNER JOIN mc_index_define t1 --None 
 on t1.index_no like 'itl_edw_pams_jxbb_dkftphz%'
 and regexp_like(','||replace(t1.index_no,'itl_edw_pams_jxbb_dkftphz:','')||',',','||t2.cpbh||',')
 and t1.etl_dt=to_date('20250429','yyyymmdd')--固定不改
 and t1.index_clsaa_f_mcs<>'盈利类'
where t2.etl_dt=to_date('${batch_date}','yyyymmdd')
 and t2.bz in ('01','0A')
GROUP BY t1.index_no_mcs
,t1.index_name_mcs
,t2.ssjgh
,t3.org_abbr
,t2.measure_no
,decode(t2.measure_no,'001','余额','002','月日均','004','年日均')
,decode(t2.bz,'01','CNY','0A','BWB','FF','BWB')
,decode(t2.bz,'01','人民币','0A','本外币合计','FF','本外币合计');
commit;


/*==============第2组==============*/

--指标结果表02:绩效报表产品筛选汇总-存款
insert into ${idl_schema}.tmp_mc_index_fact_jxkh_ind_result_2(
    index_no_mcs                                                 --指标编号_管驾
    ,index_name_mcs                                              --指标名称_管驾
    ,org_no                                                      --机构编号
    ,org_name                                                    --机构名称
    ,index_value                                                 --指标值
    -- 5
    ,measure_no                                                  --度量编号
    ,index_measure                                               --度量名称
    ,curr_no                                                     --币种代码
    ,curr_name                                                   --币种名称
    ,etl_dt                                                      --ETL处理日期
    -- 10
    ,etl_timestamp                                               --ETL处理时间戳
)
select
    t1.index_no_mcs as index_no_mcs                              --None
    ,t1.index_name_mcs as index_name_mcs                         --None
    ,t2.ssjgh as org_no                                          --None
    ,t3.org_abbr as org_name                                     --None
    ,sum(nvl(t2.index_value,0)) as index_value                   --None
    -- 5
    ,t2.measure_no as measure_no                                 --None
    ,decode(t2.measure_no,'001','当期值','002','月日均','004','年日均') as index_measure --None
    ,decode(t2.bz,'01','CNY','0A','BWB','FF','BWB') as curr_no   --None
    ,decode(t2.bz,'01','人民币','0A','本外币合计','FF','本外币合计') as curr_name --None
    ,to_date('${batch_date}','yyyymmdd') as etl_dt               --None
    -- 10
    ,TO_TIMESTAMP('${batch_timestamp}','yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp --None
 from itl_edw_pams_jxbb_ckftphz unpivot (
  index_value for measure_no in (
    zhye as  '001',
    zhyrjye as '002',
    zhnrjye as '004'
  )
) t2 --None 
INNER JOIN mtl_cmm_intnal_org_info t3 --None 
 on t2.ssjgh = t3.org_id
   and t3.etl_dt = to_date('${batch_date}','yyyymmdd')
INNER JOIN mc_index_define t1 --None 
 on t1.index_no like 'itl_edw_pams_jxbb_ckftphz%'
 and regexp_like(','||replace(t1.index_no,'itl_edw_pams_jxbb_ckftphz:','')||',',','||t2.cpmc||',')
 and t1.etl_dt=to_date('20250429','yyyymmdd')--固定不改
 and t1.index_clsaa_f_mcs<>'盈利类'

where t2.etl_dt=to_date('${batch_date}','yyyymmdd')
 and t2.bz in ('01','0A')
GROUP BY t1.index_no_mcs
,t1.index_name_mcs
,t2.ssjgh
,t3.org_abbr
,t2.measure_no
,decode(t2.measure_no,'001','余额','002','月日均','004','年日均')
,decode(t2.bz,'01','CNY','0A','BWB','FF','BWB')
,decode(t2.bz,'01','人民币','0A','本外币合计','FF','本外币合计')
;
commit;


/*==============第3组==============*/

--指标结果表02:绩效报表产品筛选汇总-存款明细
insert into ${idl_schema}.tmp_mc_index_fact_jxkh_ind_result_2(
    index_no_mcs                                                 --指标编号_管驾
    ,index_name_mcs                                              --指标名称_管驾
    ,org_no                                                      --机构编号
    ,org_name                                                    --机构名称
    ,index_value                                                 --指标值
    -- 5
    ,measure_no                                                  --度量编号
    ,index_measure                                               --度量名称
    ,curr_no                                                     --币种代码
    ,curr_name                                                   --币种名称
    ,etl_dt                                                      --ETL处理日期
    -- 10
    ,etl_timestamp                                               --ETL处理时间戳
)
select
    'JX010203030' as index_no_mcs                                --None
    ,'兴惠存' as index_name_mcs                                     --None
    ,t2.gsjgdh as org_no                                         --None
    ,t3.org_abbr as org_name                                     --None
    ,sum(nvl(t2.index_value,0)) as index_value                   --None
    -- 5
    ,t2.measure_no as measure_no                                 --None
    ,decode(t2.measure_no,'001','当期值','002','月日均','004','年日均') as index_measure --None
    ,'BWB' as curr_no                                            --None
    ,'本外币合计' as curr_name                                        --None
    ,to_date('${batch_date}','yyyymmdd') as etl_dt               --None
    -- 10
    ,TO_TIMESTAMP('${batch_timestamp}','yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp --None
 from itl_edw_pams_jxbb_ckftpmx unpivot (
  index_value for measure_no in (
    zhye as  '001',
    zhyrjye as '002',
    zhnrjye as '004'
  )
) t2 --None 
INNER JOIN mtl_cmm_intnal_org_info t3 --None 
 on t2.gsjgdh = t3.org_id
   and t3.etl_dt = to_date('${batch_date}','yyyymmdd')
INNER JOIN itl_edw_cmm_dep_acct_attach_info t4 --None 
 on t4.etl_dt=to_date('${batch_date}','yyyymmdd')
 and t2.zhdh=t4.acct_id
 and t4.xhc_flg = '1'

where t2.etl_dt=to_date('${batch_date}','yyyymmdd')
GROUP BY t2.gsjgdh
,t3.org_abbr
,t2.measure_no
,decode(t2.measure_no,'001','余额','002','月日均','004','年日均')
;
commit;


/*==============第4组==============*/

--指标结果表02:绩效贷款FTP明细汇总-零售不良资产额（分产品）
insert into ${idl_schema}.tmp_mc_index_fact_jxkh_ind_result_2(
    index_no_mcs                                                 --指标编号_管驾
    ,index_name_mcs                                              --指标名称_管驾
    ,org_no                                                      --机构编号
    ,org_name                                                    --机构名称
    ,index_value                                                 --指标值
    -- 5
    ,measure_no                                                  --度量编号
    ,index_measure                                               --度量名称
    ,curr_no                                                     --币种代码
    ,curr_name                                                   --币种名称
    ,etl_dt                                                      --ETL处理日期
    -- 10
    ,etl_timestamp                                               --ETL处理时间戳
)
select
    t1.index_no_mcs as index_no_mcs                              --None
    ,t1.index_name_mcs as index_name_mcs                         --None
    ,t2.ssjgh as org_no                                          --None
    ,t3.org_abbr as org_name                                     --None
    ,sum(case when t2.wjfl in ('次级','可疑','损失') then nvl(t2.YE,0) else 0 end) as index_value --None
    -- 5
    ,'001' as measure_no                                         --None
    ,'当前值' as index_measure                                      --None
    ,'BWB' as curr_no                                            --None
    ,'本外币合计' as curr_name                                        --None
    ,to_date('${batch_date}','yyyymmdd') as etl_dt               --None
    -- 10
    ,TO_TIMESTAMP('${batch_timestamp}','yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp --None
 from itl_edw_pams_jxbb_dkftpmx t2 --None 
INNER JOIN mtl_cmm_intnal_org_info t3 --None 
 on t2.ssjgh = t3.org_id
   and t3.etl_dt = to_date('${batch_date}','yyyymmdd')
INNER JOIN mc_index_define t1 --None 
 on t1.index_no like 'itl_edw_pams_jxbb_dkftpmx%'
 and regexp_like(','||replace(t1.index_no,'itl_edw_pams_jxbb_dkftpmx:','')||',',','||t2.cpbh||',')
 and t1.etl_dt=to_date('20250429','yyyymmdd')--固定不改
 and t1.index_clsaa_f_mcs<>'盈利类'

where t2.etl_dt=to_date('${batch_date}','yyyymmdd')
GROUP BY t1.index_no_mcs
,t1.index_name_mcs
,t2.ssjgh
,t3.org_abbr
;
commit;


/*==============第5组==============*/

--指标结果表02:同业存单明细汇总-同业存单规模
insert into ${idl_schema}.tmp_mc_index_fact_jxkh_ind_result_2(
    index_no_mcs                                                 --指标编号_管驾
    ,index_name_mcs                                              --指标名称_管驾
    ,org_no                                                      --机构编号
    ,org_name                                                    --机构名称
    ,index_value                                                 --指标值
    -- 5
    ,measure_no                                                  --度量编号
    ,index_measure                                               --度量名称
    ,curr_no                                                     --币种代码
    ,curr_name                                                   --币种名称
    ,etl_dt                                                      --ETL处理日期
    -- 10
    ,etl_timestamp                                               --ETL处理时间戳
)
select
    'JX010202039' as index_no_mcs                                --None
    ,'同业存单规模' as index_name_mcs                                  --None
    ,'896821' as org_no                                          --None
    ,'资金交易部 ' as org_name                                        --None
    ,sum(nvl(t2.index_value,0)) as index_value                   --None
    -- 5
    ,t2.measure_no as measure_no                                 --None
    ,decode(t2.measure_no,'001','当期值','002','月日均','004','年日均') as index_measure --None
    ,'BWB' as curr_no                                            --None
    ,'本外币合计' as curr_name                                        --None
    ,to_date('${batch_date}','yyyymmdd') as etl_dt               --None
    -- 10
    ,TO_TIMESTAMP('${batch_timestamp}','yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp --None
 from itl_edw_pams_jxbb_tycdmx unpivot (
  index_value for measure_no in (
    bqye as  '001',
    yrj as '002',
    nrj as '004'
  )
) t2 --None 

where t2.etl_dt=to_date('${batch_date}','yyyymmdd')
and t2.ssjgmc like '%资金交易部%'
and t2.tjrq = '${batch_date}'
and t2.FPJS='1'
GROUP BY t2.measure_no
,decode(t2.measure_no,'001','当期值','002','月日均','004','年日均')
;
commit;


/*==============第6组==============*/

--指标结果表01:绩效指标结果表
whenever sqlerror continue none;
drop table ${idl_schema}.tmp_mc_index_fact_jxkh_ind_result_1 purge;
whenever sqlerror exit sql.sqlcode;
create table ${idl_schema}.tmp_mc_index_fact_jxkh_ind_result_1 (
    index_no_mcs varchar2(60)                                     --指标编号_管驾
    ,index_name_mcs varchar2(500) --指标名称_管驾
    ,org_no varchar2(60) --机构编号
    ,org_name varchar2(500) --机构名称
    ,index_value number(38,8) --指标值
    -- 5
    ,measure_no varchar2(150) --度量编号
    ,index_measure varchar2(500) --度量名称
    ,curr_no varchar2(10) --币种代码
    ,curr_name varchar2(500) --币种名称
    ,etl_dt date --ETL处理日期
    -- 10
    ,etl_timestamp timestamp(6) --ETL处理时间戳
)
 ;

insert into ${idl_schema}.tmp_mc_index_fact_jxkh_ind_result_1(
    index_no_mcs                                                 --指标编号_管驾
    ,index_name_mcs                                              --指标名称_管驾
    ,org_no                                                      --机构编号
    ,org_name                                                    --机构名称
    ,index_value                                                 --指标值
    -- 5
    ,measure_no                                                  --度量编号
    ,index_measure                                               --度量名称
    ,curr_no                                                     --币种代码
    ,curr_name                                                   --币种名称
    ,etl_dt                                                      --ETL处理日期
    -- 10
    ,etl_timestamp                                               --ETL处理时间戳
)
select
    t1.index_no_mcs as index_no_mcs                              --None
    ,t1.index_name_mcs as index_name_mcs                         --None
    ,t3.jgdh as org_no                                           --None
    ,t3.jgqc as org_name                                         --None
    ,nvl(t2.zbz,0) as index_value                                --None
    -- 5
    ,decode(t2.sdbs,'1','001','2','002','4','004') as measure_no --None
    ,decode(t2.sdbs,'1','当期值','2','月日均','4','年日均') as index_measure --None
    ,decode(t2.bz,'01','CNY','0A','BWB','FF','BWB') as curr_no   --None
    ,decode(t2.bz,'01','人民币','0A','本外币合计','FF','本外币合计') as curr_name --None
    ,to_date('${batch_date}','yyyymmdd') as etl_dt               --None
    -- 10
    ,TO_TIMESTAMP('${batch_timestamp}','yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp --None
 from itl_edw_pams_v_yjzb_jg t2 --None 
INNER JOIN itl_edw_pams_khdx_jg t3 --None 
 on t3.khdxdh=t2.khdxdh
  and t3.etl_dt=to_date('${batch_date}','yyyymmdd')
INNER JOIN mc_index_define t1 --None 
 on to_char(t2.zbdh)=t1.index_no
 and t1.etl_dt=to_date('20250429','yyyymmdd')--固定不改
 and t1.index_clsaa_f_mcs<>'盈利类'
where t2.etl_dt=to_date('${batch_date}','yyyymmdd')
 and t2.tjrq='${batch_date}'
 and t2.tjkj='1' --统计口径：0-会计口径，1-考核口径
 and t2.sdbs in ('1','2','4')--指标时段：1-时点，2-月日均，3-季日均，4-年日均，5-月累计，6-季累计，7-年累计 
 and t2.bz in ('01','0A','FF')--币种：01-人民币，0A-本外币合计，0B-外币折人民币，0C-外币折美元，FF-非币种
 ;
commit;


/*==============第7组==============*/

--指标结果表01:财务集市指标结果表
insert into ${idl_schema}.tmp_mc_index_fact_jxkh_ind_result_1(
    index_no_mcs                                                 --指标编号_管驾
    ,index_name_mcs                                              --指标名称_管驾
    ,org_no                                                      --机构编号
    ,org_name                                                    --机构名称
    ,index_value                                                 --指标值
    -- 5
    ,measure_no                                                  --度量编号
    ,index_measure                                               --度量名称
    ,curr_no                                                     --币种代码
    ,curr_name                                                   --币种名称
    ,etl_dt                                                      --ETL处理日期
    -- 10
    ,etl_timestamp                                               --ETL处理时间戳
)
select
    t1.index_no_mcs as index_no_mcs                              --None
    ,t1.index_name_mcs as index_name_mcs                         --None
    ,t2.org_no as org_no                                         --None
    ,t3.org_abbr as org_name                                     --None
    ,nvl(t2.index_val,0) as index_value                          --None
    -- 5
    ,t2.index_measure as measure_no                              --None
    ,decode(t2.index_measure,'001','当期值','002','月日均','004','年日均') as index_measure --None
    ,t2.curr_cd as curr_no                                       --None
    ,decode(t2.curr_cd,'CNY','人民币','BWB','本外币合计') as curr_name   --None
    ,to_date('${batch_date}','yyyymmdd') as etl_dt               --None
    -- 10
    ,TO_TIMESTAMP('${batch_timestamp}','yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp --None
 from mtl_fdl_idx_index_data t2 --None 
INNER JOIN mtl_fml_f99_int_org_info_new t3 --None 
 on t2.org_no = t3.org_id
   
   and t3.etl_dt = to_date('${batch_date}','yyyymmdd')
INNER JOIN mc_index_define t1 --None 
 on t2.index_no=t1.index_no
 and t1.etl_dt=to_date('20250429','yyyymmdd')--固定不改
 and t1.index_clsaa_f_mcs<>'盈利类'

where t2.etl_dt=to_date('${batch_date}','yyyymmdd')
 and t2.curr_cd in ('CNY','BWB')
 and t2.INDEX_MEASURE in ('001','002','004')
 
;
commit;


/*==============第8组==============*/

--指标结果表01:财务集市组合指标结果表(JX010202040)
insert into ${idl_schema}.tmp_mc_index_fact_jxkh_ind_result_1(
    index_no_mcs                                                 --指标编号_管驾
    ,index_name_mcs                                              --指标名称_管驾
    ,org_no                                                      --机构编号
    ,org_name                                                    --机构名称
    ,index_value                                                 --指标值
    -- 5
    ,measure_no                                                  --度量编号
    ,index_measure                                               --度量名称
    ,curr_no                                                     --币种代码
    ,curr_name                                                   --币种名称
    ,etl_dt                                                      --ETL处理日期
    -- 10
    ,etl_timestamp                                               --ETL处理时间戳
)
select
    'JX010202040' as index_no_mcs                                --None
    ,'回购及拆入规模' as index_name_mcs                                 --None
    ,t2.org_no as org_no                                         --None
    ,t3.org_abbr as org_name                                     --None
    ,sum(nvl(t2.index_val,0)) as index_value                     --None
    -- 5
    ,t2.index_measure as measure_no                              --None
    ,decode(t2.index_measure,'001','当期值','002','月日均','004','年日均') as index_measure --None
    ,t2.curr_cd as curr_no                                       --None
    ,decode(t2.curr_cd,'CNY','人民币','BWB','本外币合计') as curr_name   --None
    ,to_date('${batch_date}','yyyymmdd') as etl_dt               --None
    -- 10
    ,TO_TIMESTAMP('${batch_timestamp}','yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp --None
 from mtl_fdl_idx_index_data t2 --None 
INNER JOIN mtl_fml_f99_int_org_info_new t3 --None 
 on t2.org_no = t3.org_id
   
   and t3.etl_dt = to_date('${batch_date}','yyyymmdd')

where t2.etl_dt=to_date('${batch_date}','yyyymmdd')
 and t2.curr_cd in ('CNY','BWB')
 and t2.INDEX_MEASURE in ('001','002','004')
 and t2.index_no in ('FM0100125','FM0100075')
GROUP BY t2.org_no
,t3.org_abbr
,t2.index_measure
,decode(t2.index_measure,'001','当期值','002','月日均','004','年日均')
,t2.curr_cd
,decode(t2.curr_cd,'CNY','人民币','BWB','本外币合计')
;
commit;


/*==============第9组==============*/

--指标结果表01:公司指标汇总表
insert into ${idl_schema}.tmp_mc_index_fact_jxkh_ind_result_1(
    index_no_mcs                                                 --指标编号_管驾
    ,index_name_mcs                                              --指标名称_管驾
    ,org_no                                                      --机构编号
    ,org_name                                                    --机构名称
    ,index_value                                                 --指标值
    -- 5
    ,measure_no                                                  --度量编号
    ,index_measure                                               --度量名称
    ,curr_no                                                     --币种代码
    ,curr_name                                                   --币种名称
    ,etl_dt                                                      --ETL处理日期
    -- 10
    ,etl_timestamp                                               --ETL处理时间戳
)
select
    t1.index_no_mcs as index_no_mcs                              --None
    ,t1.index_name_mcs as index_name_mcs                         --None
    ,t2.org_or_user_id as org_no                                 --None
    ,t3.org_abbr as org_name                                     --None
    ,nvl(t2.value,0) as index_value                              --None
    -- 5
    ,decode(t2.index_cycle,'D','001','M','002','Y','004') as measure_no --None
    ,decode(t2.index_cycle,'D','当期值','M','月日均','Y','年日均') as index_measure --None
    ,'BWB' as curr_no                                            --None
    ,'本外币合计' as curr_name                                        --None
    ,to_date('${batch_date}','yyyymmdd') as etl_dt               --None
    -- 10
    ,TO_TIMESTAMP('${batch_timestamp}','yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp --None
 from itl_ccrw_u_ip_result_ccrw_mcss t2 --None 
INNER JOIN mtl_cmm_intnal_org_info t3 --None 
 on t2.org_or_user_id = t3.org_id
   and t3.etl_dt = to_date('${batch_date}','yyyymmdd')
INNER JOIN mc_index_define t1 --None 
 on t1.index_no=t2.bk_index_id
 and t1.etl_dt=to_date('20250429','yyyymmdd')--固定不改
 and t1.index_clsaa_f_mcs<>'盈利类'

where t2.etl_dt=to_date('${batch_date}','yyyymmdd')
 and t2.FIT_OBJ='ORG'
 and t2.ccy_type='2'
 
;
commit;


/*==============第10组==============*/

--指标结果表01:同业指标汇总表
insert into ${idl_schema}.tmp_mc_index_fact_jxkh_ind_result_1(
    index_no_mcs                                                 --指标编号_管驾
    ,index_name_mcs                                              --指标名称_管驾
    ,org_no                                                      --机构编号
    ,org_name                                                    --机构名称
    ,index_value                                                 --指标值
    -- 5
    ,measure_no                                                  --度量编号
    ,index_measure                                               --度量名称
    ,curr_no                                                     --币种代码
    ,curr_name                                                   --币种名称
    ,etl_dt                                                      --ETL处理日期
    -- 10
    ,etl_timestamp                                               --ETL处理时间戳
)
select
    t1.index_no_mcs as index_no_mcs                              --None
    ,t1.index_name_mcs as index_name_mcs                         --None
    ,t2.ORG_OR_USER_ID as org_no                                 --None
    ,t3.org_abbr as org_name                                     --None
    ,sum(nvl(t2.value,0)) as index_value                         --None
    -- 5
    ,'001' as measure_no                                         --None
    ,'当期值' as index_measure                                      --None
    ,'BWB' as curr_no                                            --None
    ,'本外币合计' as curr_name                                        --None
    ,to_date('${batch_date}','yyyymmdd') as etl_dt               --None
    -- 10
    ,TO_TIMESTAMP('${batch_timestamp}','yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp --None
 from itl_ccrw_u_ip_result_icrw_mcss t2 --None 
INNER JOIN mtl_cmm_intnal_org_info t3 --None 
 on t2.ORG_OR_USER_ID = t3.org_id
   and t3.etl_dt = to_date('${batch_date}','yyyymmdd')
INNER JOIN mc_index_define t1 --None 
 on t1.index_no like 'itl_ccrw_u_ip_result_icrw_mcss%'
 and regexp_like(','||replace(t1.index_no,'itl_ccrw_u_ip_result_icrw_mcss:','')||',',','||t2.INDEX_MX_ID||',')
 and t1.etl_dt=to_date('20250429','yyyymmdd')--固定不改
 and t1.index_clsaa_f_mcs='客户及其他类'

where t2.etl_dt=to_date('${batch_date}','yyyymmdd')
 and t2.FIT_OBJ='ORG'
 and t2.ccy_type in('2','6')
 AND ((T2.INDEX_CYCLE_VALUE='${batch_date}'and T2.INDEX_CYCLE='D') or T2.INDEX_CYCLE<>'D')
GROUP BY t1.index_no_mcs
,t1.index_name_mcs
,t2.ORG_OR_USER_ID
,t3.org_abbr
;
commit;


/*==============第11组==============*/

--指标结果表01:同业指标汇总表-全行
insert into ${idl_schema}.tmp_mc_index_fact_jxkh_ind_result_1(
    index_no_mcs                                                 --指标编号_管驾
    ,index_name_mcs                                              --指标名称_管驾
    ,org_no                                                      --机构编号
    ,org_name                                                    --机构名称
    ,index_value                                                 --指标值
    -- 5
    ,measure_no                                                  --度量编号
    ,index_measure                                               --度量名称
    ,curr_no                                                     --币种代码
    ,curr_name                                                   --币种名称
    ,etl_dt                                                      --ETL处理日期
    -- 10
    ,etl_timestamp                                               --ETL处理时间戳
)
select
    t1.index_no_mcs as index_no_mcs                              --None
    ,t1.index_name_mcs as index_name_mcs                         --None
    ,t3.org_id as org_no                                         --None
    ,t3.org_abbr as org_name                                     --None
    ,sum(nvl(t2.value,0)) as index_value                         --None
    -- 5
    ,case when t2.index_mx_id in ('BM01375',
'CW00615',
'CW10007',
'BM00617',
'CW00477',
'CW00498',
'CW00510',
'CW00522',
'CW00714') then '001'
     when t2.index_mx_id in ('BM00119',
'CW00616',
'CW10008',
'BM00615',
'CW00478',
'CW00499',
'CW00511',
'CW00523',
'CW00715') then '002'
    when t2.index_mx_id in ('BM00103',
'CW00617',
'CW10009',
'BM00616',
'CW00479',
'CW00500',
'CW00512',
'CW00524',
'CW00716') then '004' end as measure_no --None
    ,case when t2.index_mx_id in ('BM01375',
'CW00615',
'CW10007',
'BM00617',
'CW00477',
'CW00498',
'CW00510',
'CW00522',
'CW00714') then '当期值'
     when t2.index_mx_id in ('BM00119',
'CW00616',
'CW10008',
'BM00615',
'CW00478',
'CW00499',
'CW00511',
'CW00523',
'CW00715') then '月日均'
    when t2.index_mx_id in ('BM00103',
'CW00617',
'CW10009',
'BM00616',
'CW00479',
'CW00500',
'CW00512',
'CW00524',
'CW00716') then '年日均' end as index_measure --None
    ,'BWB' as curr_no                                            --None
    ,'本外币合计' as curr_name                                        --None
    ,to_date('${batch_date}','yyyymmdd') as etl_dt               --None
    -- 10
    ,TO_TIMESTAMP('${batch_timestamp}','yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp --None
 from itl_ccrw_u_ip_result_icrw_mcss t2 --None 
INNER JOIN mtl_cmm_intnal_org_info t3 --None 
 on (case when t2.ORG_OR_USER_ID like 'HZJG896811%'then '000000' end )  = t3.org_id
   and t3.etl_dt = to_date('${batch_date}','yyyymmdd')
INNER JOIN mc_index_define t1 --None 
 on t1.index_no_mcs =(case when t2.index_mx_id in ('BM01375','BM00119','BM00103') then 'JX010101023'
         when t2.index_mx_id in ('CW00714','CW00715','CW00716') then 'JX010102024'
         when t2.index_mx_id in ('CW00615','CW00616','CW00617') then 'JX010102026'
         when t2.index_mx_id in ('CW10007','CW10008','CW10009') then 'JX010102027'
         when t2.index_mx_id in ('BM00617','BM00615','BM00616') then 'JX010201042'
         when t2.index_mx_id in ('CW00477','CW00478','CW00479') then 'JX010202043'
         when t2.index_mx_id in ('CW00498','CW00499','CW00500') then 'JX010202044'
         when t2.index_mx_id in ('CW00510','CW00511','CW00512') then 'JX010202045'
         when t2.index_mx_id in ('CW00522','CW00523','CW00524') then 'JX010202046'
end )
 and t1.etl_dt=to_date('20250429','yyyymmdd')--固定不改
 and t1.index_clsaa_f_mcs<>'盈利类'

where t2.etl_dt=to_date('${batch_date}','yyyymmdd')
 and t2.FIT_OBJ='ORG'
 and t2.ccy_type in('2','6')
 AND ((T2.INDEX_CYCLE_VALUE='${batch_date}'and T2.INDEX_CYCLE='D') or T2.INDEX_CYCLE<>'D')
 and t2.index_mx_id in ('BM01375'
                          ,'CW00615'
                          ,'CW10007'
                          ,'BM00617'
                          ,'CW00477'
                          ,'CW00498'
                          ,'CW00510'
                          ,'CW00522'
                          ,'BM00119'
                          ,'CW00616'
                          ,'CW10008'
                          ,'BM00615'
                          ,'CW00478'
                          ,'CW00499'
                          ,'CW00511'
                          ,'CW00523'
                          ,'BM00103'
                          ,'CW00617'
                          ,'CW10009'
                          ,'BM00616'
                          ,'CW00479'
                          ,'CW00500'
                          ,'CW00512'
                          ,'CW00524'
                          ,'CW00714','CW00715','CW00716')
       and t2.org_or_user_id like 'HZJG896811%'
GROUP BY t1.index_no_mcs
,t1.index_name_mcs
,t3.org_id
,t3.org_abbr
,case when t2.index_mx_id in ('BM01375',
'CW00615',
'CW10007',
'BM00617',
'CW00477',
'CW00498',
'CW00510',
'CW00522',
'CW00714') then '001'
     when t2.index_mx_id in ('BM00119',
'CW00616',
'CW10008',
'BM00615',
'CW00478',
'CW00499',
'CW00511',
'CW00523',
'CW00715') then '002'
    when t2.index_mx_id in ('BM00103',
'CW00617',
'CW10009',
'BM00616',
'CW00479',
'CW00500',
'CW00512',
'CW00524',
'CW00716') then '004' end
,case when t2.index_mx_id in ('BM01375',
'CW00615',
'CW10007',
'BM00617',
'CW00477',
'CW00498',
'CW00510',
'CW00522',
'CW00714') then '当期值'
     when t2.index_mx_id in ('BM00119',
'CW00616',
'CW10008',
'BM00615',
'CW00478',
'CW00499',
'CW00511',
'CW00523',
'CW00715') then '月日均'
    when t2.index_mx_id in ('BM00103',
'CW00617',
'CW10009',
'BM00616',
'CW00479',
'CW00500',
'CW00512',
'CW00524',
'CW00716') then '年日均' end
;
commit;


/*==============第12组==============*/

--指标结果表01:同业指标汇总表-分行
insert into ${idl_schema}.tmp_mc_index_fact_jxkh_ind_result_1(
    index_no_mcs                                                 --指标编号_管驾
    ,index_name_mcs                                              --指标名称_管驾
    ,org_no                                                      --机构编号
    ,org_name                                                    --机构名称
    ,index_value                                                 --指标值
    -- 5
    ,measure_no                                                  --度量编号
    ,index_measure                                               --度量名称
    ,curr_no                                                     --币种代码
    ,curr_name                                                   --币种名称
    ,etl_dt                                                      --ETL处理日期
    -- 10
    ,etl_timestamp                                               --ETL处理时间戳
)
select
    t1.index_no_mcs as index_no_mcs                              --None
    ,t1.index_name_mcs as index_name_mcs                         --None
    ,t3.org_id as org_no                                         --None
    ,t3.org_abbr as org_name                                     --None
    ,sum(nvl(t2.value,0)) as index_value                         --None
    -- 5
    ,case when t2.index_mx_id in ('CW01031',
'CW01542',
'CW10010',
'CW01034',
'CW01644',
'CW01665',
'CW01707',
'CW01677',
'CW01545') then '001'
     when t2.index_mx_id in ('CW01032',
'CW01543',
'CW10011',
'CW01035',
'CW01645',
'CW01666',
'CW01708',
'CW01678',
'CW01546') then '002'
    when t2.index_mx_id in ('CW01033',
'CW01544',
'CW10012',
'CW01035',
'CW01646',
'CW01667',
'CW01709',
'CW01679',
'CW01547'
) then '004' end as measure_no --None
    ,case when t2.index_mx_id in ('CW01031',
'CW01542',
'CW10010',
'CW01034',
'CW01644',
'CW01665',
'CW01707',
'CW01677',
'CW01545') then '当期值'
     when t2.index_mx_id in ('CW01032',
'CW01543',
'CW10011',
'CW01035',
'CW01645',
'CW01666',
'CW01708',
'CW01678',
'CW01546') then '月日均'
    when t2.index_mx_id in ('CW01033',
'CW01544',
'CW10012',
'CW01035',
'CW01646',
'CW01667',
'CW01709',
'CW01679',
'CW01547'
) then '年日均' end as index_measure --None
    ,'BWB' as curr_no                                            --None
    ,'本外币合计' as curr_name                                        --None
    ,to_date('${batch_date}','yyyymmdd') as etl_dt               --None
    -- 10
    ,TO_TIMESTAMP('${batch_timestamp}','yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp --None
 from itl_ccrw_u_ip_result_icrw_mcss t2 --None 
INNER JOIN mtl_cmm_intnal_org_info t3 --None 
 on t2.ORG_OR_USER_ID = t3.org_id
   and t3.etl_dt = to_date('${batch_date}','yyyymmdd')
INNER JOIN mc_index_define t1 --None 
 on t1.index_no_mcs =(case when t2.index_mx_id in ('CW01031','CW01032','CW01033') then 'JX010101023'
         when t2.index_mx_id in ('CW01545','CW01546','CW01547') then 'JX010102024'
         when t2.index_mx_id in ('CW01542','CW01543','CW01544') then 'JX010102026'
         when t2.index_mx_id in ('CW10010','CW10011','CW10012') then 'JX010102027'
         when t2.index_mx_id in ('CW01034','CW01035','CW01035') then 'JX010201042'
         when t2.index_mx_id in ('CW01644','CW01645','CW01646') then 'JX010202043'
         when t2.index_mx_id in ('CW01665','CW01666','CW01667') then 'JX010202044'
         when t2.index_mx_id in ('CW01707','CW01708','CW01709') then 'JX010202045'
         when t2.index_mx_id in ('CW01677','CW01678','CW01679') then 'JX010202046'
end )
 and t1.etl_dt=to_date('20250429','yyyymmdd')--固定不改
 and t1.index_clsaa_f_mcs<>'盈利类'

where t2.etl_dt=to_date('${batch_date}','yyyymmdd')
 and t2.FIT_OBJ='ORG'
 and t2.ccy_type in('2','6')
 AND ((T2.INDEX_CYCLE_VALUE='${batch_date}'and T2.INDEX_CYCLE='D') or T2.INDEX_CYCLE<>'D')
 and t2.index_mx_id in ('CW01031',
'CW01542',
'CW10010',
'CW01034',
'CW01644',
'CW01665',
'CW01707',
'CW01677',
'CW01032',
'CW01543',
'CW10011',
'CW01035',
'CW01645',
'CW01666',
'CW01708',
'CW01678',
'CW01033',
'CW01544',
'CW10012',
'CW01035',
'CW01646',
'CW01667',
'CW01709',
'CW01679',
'CW01545',
'CW01546',
'CW01547'
)
       and t2.org_or_user_id <>'000000'
GROUP BY t1.index_no_mcs
,t1.index_name_mcs
,t3.org_id
,t3.org_abbr
,case when t2.index_mx_id in ('CW01031',
'CW01542',
'CW10010',
'CW01034',
'CW01644',
'CW01665',
'CW01707',
'CW01677',
'CW01545') then '001'
     when t2.index_mx_id in ('CW01032',
'CW01543',
'CW10011',
'CW01035',
'CW01645',
'CW01666',
'CW01708',
'CW01678',
'CW01546') then '002'
    when t2.index_mx_id in ('CW01033',
'CW01544',
'CW10012',
'CW01035',
'CW01646',
'CW01667',
'CW01709',
'CW01679',
'CW01547'
) then '004' end
,case when t2.index_mx_id in ('CW01031',
'CW01542',
'CW10010',
'CW01034',
'CW01644',
'CW01665',
'CW01707',
'CW01677',
'CW01545') then '当期值'
     when t2.index_mx_id in ('CW01032',
'CW01543',
'CW10011',
'CW01035',
'CW01645',
'CW01666',
'CW01708',
'CW01678',
'CW01546') then '月日均'
    when t2.index_mx_id in ('CW01033',
'CW01544',
'CW10012',
'CW01035',
'CW01646',
'CW01667',
'CW01709',
'CW01679',
'CW01547'
) then '年日均' end
;
commit;


/*==============第13组==============*/

--指标结果表01:同业指标汇总表-手动-全行
insert into ${idl_schema}.tmp_mc_index_fact_jxkh_ind_result_1(
    index_no_mcs                                                 --指标编号_管驾
    ,index_name_mcs                                              --指标名称_管驾
    ,org_no                                                      --机构编号
    ,org_name                                                    --机构名称
    ,index_value                                                 --指标值
    -- 5
    ,measure_no                                                  --度量编号
    ,index_measure                                               --度量名称
    ,curr_no                                                     --币种代码
    ,curr_name                                                   --币种名称
    ,etl_dt                                                      --ETL处理日期
    -- 10
    ,etl_timestamp                                               --ETL处理时间戳
)
select
    t1.index_no_mcs as index_no_mcs                              --None
    ,t1.index_name_mcs as index_name_mcs                         --None
    ,t3.org_id as org_no                                         --None
    ,t3.org_abbr as org_name                                     --None
    ,sum(nvl(t2.value,0)) as index_value                         --None
    -- 5
    ,case when t2.index_mx_id in (
'CW00552',
'CW00594') then '001'
     when t2.index_mx_id in (
'CW00553',
'CW00595') then '002'
    when t2.index_mx_id in (
'CW00554',
'CW00596') then '004' end as measure_no --None
    ,case when t2.index_mx_id in (
'CW00552',
'CW00594') then '当期值'
     when t2.index_mx_id in (
'CW00553',
'CW00595') then '月日均'
    when t2.index_mx_id in (
'CW00554',
'CW00596') then '年日均' end as index_measure --None
    ,'BWB' as curr_no                                            --None
    ,'本外币合计' as curr_name                                        --None
    ,to_date('${batch_date}','yyyymmdd') as etl_dt               --None
    -- 10
    ,TO_TIMESTAMP('${batch_timestamp}','yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp --None
 from itl_ccrw_u_ip_result_icrw_mcss t2 --None 
INNER JOIN mtl_cmm_intnal_org_info t3 --None 
 on (case when t2.ORG_OR_USER_ID like 'HZJG896811%'then '000000' end )  = t3.org_id
   and t3.etl_dt = to_date('${batch_date}','yyyymmdd')
INNER JOIN mc_index_define t1 --None 
 on t1.index_no_mcs =(case when t2.index_mx_id in ('CW00552','CW00594',
'CW00553','CW00595',
'CW00554','CW00596') then 'JX010102025'
end )
 and t1.etl_dt=to_date('20250429','yyyymmdd')--固定不改
 and t1.index_clsaa_f_mcs<>'盈利类'

where t2.etl_dt=to_date('${batch_date}','yyyymmdd')
 and t2.FIT_OBJ='ORG'
 and t2.ccy_type in('2','6')
 AND ((T2.INDEX_CYCLE_VALUE='${batch_date}'and T2.INDEX_CYCLE='D') or T2.INDEX_CYCLE<>'D')
 and t2.index_mx_id in (
'CW00552','CW00594',
'CW00553','CW00595',
'CW00554','CW00596')
       and t2.org_or_user_id like 'HZJG896811%'
GROUP BY t1.index_no_mcs
,t1.index_name_mcs
,t3.org_id
,t3.org_abbr
,case when t2.index_mx_id in (
'CW00552',
'CW00594') then '001'
     when t2.index_mx_id in (
'CW00553',
'CW00595') then '002'
    when t2.index_mx_id in (
'CW00554',
'CW00596') then '004' end
,case when t2.index_mx_id in (
'CW00552',
'CW00594') then '当期值'
     when t2.index_mx_id in (
'CW00553',
'CW00595') then '月日均'
    when t2.index_mx_id in (
'CW00554',
'CW00596') then '年日均' end
;
commit;


/*==============第14组==============*/

--指标结果表01:同业指标汇总表-手动-分行
insert into ${idl_schema}.tmp_mc_index_fact_jxkh_ind_result_1(
    index_no_mcs                                                 --指标编号_管驾
    ,index_name_mcs                                              --指标名称_管驾
    ,org_no                                                      --机构编号
    ,org_name                                                    --机构名称
    ,index_value                                                 --指标值
    -- 5
    ,measure_no                                                  --度量编号
    ,index_measure                                               --度量名称
    ,curr_no                                                     --币种代码
    ,curr_name                                                   --币种名称
    ,etl_dt                                                      --ETL处理日期
    -- 10
    ,etl_timestamp                                               --ETL处理时间戳
)
select
    t1.index_no_mcs as index_no_mcs                              --None
    ,t1.index_name_mcs as index_name_mcs                         --None
    ,t3.org_id as org_no                                         --None
    ,t3.org_abbr as org_name                                     --None
    ,sum(nvl(t2.value,0)) as index_value                         --None
    -- 5
    ,case when t2.index_mx_id in ('CW01545',
'CW01605',
'CW01051',
'CW01521') then '001'
     when t2.index_mx_id in ('CW01546',
'CW01606',
'CW01052',
'CW01522') then '002'
    when t2.index_mx_id in ('CW01547',
'CW01607',
'CW01053',
'CW01523'
) then '004' end as measure_no --None
    ,case when t2.index_mx_id in ('CW01545',
'CW01605',
'CW01051',
'CW01521') then '当期值'
     when t2.index_mx_id in ('CW01546',
'CW01606',
'CW01052',
'CW01522') then '月日均'
    when t2.index_mx_id in ('CW01547',
'CW01607',
'CW01053',
'CW01523'
) then '年日均' end as index_measure --None
    ,'BWB' as curr_no                                            --None
    ,'本外币合计' as curr_name                                        --None
    ,to_date('${batch_date}','yyyymmdd') as etl_dt               --None
    -- 10
    ,TO_TIMESTAMP('${batch_timestamp}','yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp --None
 from itl_ccrw_u_ip_result_icrw_mcss t2 --None 
INNER JOIN mtl_cmm_intnal_org_info t3 --None 
 on t2.ORG_OR_USER_ID = t3.org_id
   and t3.etl_dt = to_date('${batch_date}','yyyymmdd')
INNER JOIN mc_index_define t1 --None 
 on t1.index_no_mcs =(case when t2.index_mx_id in ('CW01051','CW01521',
'CW01052','CW01522',
'CW01051','CW01523') then 'JX010102025'
end )
 and t1.etl_dt=to_date('20250429','yyyymmdd')--固定不改
 and t1.index_clsaa_f_mcs<>'盈利类'

where t2.etl_dt=to_date('${batch_date}','yyyymmdd')
 and t2.FIT_OBJ='ORG'
 and t2.ccy_type in('2','6')
 AND ((T2.INDEX_CYCLE_VALUE='${batch_date}'and T2.INDEX_CYCLE='D') or T2.INDEX_CYCLE<>'D')
 and t2.index_mx_id in (
'CW01051','CW01521',
'CW01052','CW01522',
'CW01051','CW01523'
)
       and t2.org_or_user_id <>'000000'
GROUP BY t1.index_no_mcs
,t1.index_name_mcs
,t3.org_id
,t3.org_abbr
,case when t2.index_mx_id in ('CW01545',
'CW01605',
'CW01051',
'CW01521') then '001'
     when t2.index_mx_id in ('CW01546',
'CW01606',
'CW01052',
'CW01522') then '002'
    when t2.index_mx_id in ('CW01547',
'CW01607',
'CW01053',
'CW01523'
) then '004' end
,case when t2.index_mx_id in ('CW01545',
'CW01605',
'CW01051',
'CW01521') then '当期值'
     when t2.index_mx_id in ('CW01546',
'CW01606',
'CW01052',
'CW01522') then '月日均'
    when t2.index_mx_id in ('CW01547',
'CW01607',
'CW01053',
'CW01523'
) then '年日均' end
;
commit;


/*==============第15组==============*/

--指标结果表01:财务集市绩效指标结果表
insert into ${idl_schema}.tmp_mc_index_fact_jxkh_ind_result_1(
    index_no_mcs                                                 --指标编号_管驾
    ,index_name_mcs                                              --指标名称_管驾
    ,org_no                                                      --机构编号
    ,org_name                                                    --机构名称
    ,index_value                                                 --指标值
    -- 5
    ,measure_no                                                  --度量编号
    ,index_measure                                               --度量名称
    ,curr_no                                                     --币种代码
    ,curr_name                                                   --币种名称
    ,etl_dt                                                      --ETL处理日期
    -- 10
    ,etl_timestamp                                               --ETL处理时间戳
)
select
    t1.index_no_mcs as index_no_mcs                              --None
    ,t1.index_name_mcs as index_name_mcs                         --None
    ,t2.org_no as org_no                                         --None
    ,t3.org_abbr as org_name                                     --None
    ,nvl(t2.index_val,0) as index_value                          --None
    -- 5
    ,t2.index_measure as measure_no                              --None
    ,decode(t2.index_measure,'001','当期值','002','月日均','004','年日均') as index_measure --None
    ,t2.curr_cd as curr_no                                       --None
    ,decode(t2.curr_cd,'CNY','人民币','BWB','本外币合计') as curr_name   --None
    ,to_date('${batch_date}','yyyymmdd') as etl_dt               --None
    -- 10
    ,TO_TIMESTAMP('${batch_timestamp}','yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp --None
 from mtl_fdl_idx_index_data_jx t2 --None 
INNER JOIN mtl_fml_f99_int_org_info_new t3 --None 
 on t2.org_no = t3.org_id
   
   and t3.etl_dt = to_date('${batch_date}','yyyymmdd')
INNER JOIN mc_index_define t1 --None 
 on t2.index_no=t1.index_no
 and t1.etl_dt=to_date('20250429','yyyymmdd')--固定不改
 and t1.index_clsaa_f_mcs<>'盈利类'

where t2.etl_dt=to_date('${batch_date}','yyyymmdd')
 and t2.curr_cd in ('CNY','BWB')
 and t2.INDEX_MEASURE in ('001','002','004')
 
;
commit;


/*==============第16组==============*/

--指标结果表01:零售平台指标结果表
insert into ${idl_schema}.tmp_mc_index_fact_jxkh_ind_result_1(
    index_no_mcs                                                 --指标编号_管驾
    ,index_name_mcs                                              --指标名称_管驾
    ,org_no                                                      --机构编号
    ,org_name                                                    --机构名称
    ,index_value                                                 --指标值
    -- 5
    ,measure_no                                                  --度量编号
    ,index_measure                                               --度量名称
    ,curr_no                                                     --币种代码
    ,curr_name                                                   --币种名称
    ,etl_dt                                                      --ETL处理日期
    -- 10
    ,etl_timestamp                                               --ETL处理时间戳
)
select
    t1.index_no_mcs as index_no_mcs                              --None
    ,t1.index_name_mcs as index_name_mcs                         --None
    ,t2.belong_org_id as org_no                                  --None
    ,t3.org_abbr as org_name                                     --None
    ,sum(nvl(t2.VAL,0)) as index_value                           --None
    -- 5
    ,'001' as measure_no                                         --None
    ,'当前值' as index_measure                                      --None
    ,'BWB' as curr_no                                            --None
    ,'本外币合计' as curr_name                                        --None
    ,to_date('${batch_date}','yyyymmdd') as etl_dt               --None
    -- 10
    ,TO_TIMESTAMP('${batch_timestamp}','yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp --None
 from itl_bdws_u_cust_jsh_ind_info t2 --None 
INNER JOIN mtl_cmm_intnal_org_info t3 --None 
 on t2.belong_org_id = t3.org_id
   
   and t3.etl_dt = to_date('${batch_date}','yyyymmdd')
INNER JOIN mc_index_define t1 --None 
 on t2.index_no=t1.index_no
 and t1.etl_dt=to_date('20250429','yyyymmdd')--固定不改
 and t1.index_clsaa_f_mcs<>'盈利类'

where t2.etl_dt=to_date('${batch_date}','yyyymmdd')
 and t2.execut_type ='1'
GROUP BY t1.index_no_mcs
,t1.index_name_mcs
,t2.belong_org_id
,t3.org_abbr
;
commit;


/*==============第17组==============*/

--指标结果表01:绩效报表产品筛选汇总-存贷款-支行回插
insert into ${idl_schema}.tmp_mc_index_fact_jxkh_ind_result_1(
    index_no_mcs                                                 --指标编号_管驾
    ,index_name_mcs                                              --指标名称_管驾
    ,org_no                                                      --机构编号
    ,org_name                                                    --机构名称
    ,index_value                                                 --指标值
    -- 5
    ,measure_no                                                  --度量编号
    ,index_measure                                               --度量名称
    ,curr_no                                                     --币种代码
    ,curr_name                                                   --币种名称
    ,etl_dt                                                      --ETL处理日期
    -- 10
    ,etl_timestamp                                               --ETL处理时间戳
)
select
    t2.INDEX_NO_MCS as index_no_mcs                              --指标编号_管驾
    ,t2.INDEX_NAME_MCS as index_name_mcs                         --指标名称_管驾
    ,t2.ORG_NO as org_no                                         --机构编号
    ,t2.ORG_NAME as org_name                                     --机构名称
    ,t2.INDEX_VALUE as index_value                               --指标值
    -- 5
    ,t2.MEASURE_NO as measure_no                                 --度量编号
    ,t2.INDEX_MEASURE as index_measure                           --度量名称
    ,t2.CURR_NO as curr_no                                       --币种代码
    ,t2.CURR_NAME as curr_name                                   --币种名称
    ,to_date('${batch_date}','yyyymmdd') as etl_dt               --ETL处理日期
    -- 10
    ,TO_TIMESTAMP('${batch_timestamp}','yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp --ETL处理时间戳
 from tmp_mc_index_fact_jxkh_ind_result_2 t2 --None 

where length(t2.org_no)>3
 and t2.org_no<>'000000'
 
;
commit;


/*==============第18组==============*/

--指标结果表01:绩效报表产品筛选汇总-存贷款-分行汇总
insert into ${idl_schema}.tmp_mc_index_fact_jxkh_ind_result_1(
    index_no_mcs                                                 --指标编号_管驾
    ,index_name_mcs                                              --指标名称_管驾
    ,org_no                                                      --机构编号
    ,org_name                                                    --机构名称
    ,index_value                                                 --指标值
    -- 5
    ,measure_no                                                  --度量编号
    ,index_measure                                               --度量名称
    ,curr_no                                                     --币种代码
    ,curr_name                                                   --币种名称
    ,etl_dt                                                      --ETL处理日期
    -- 10
    ,etl_timestamp                                               --ETL处理时间戳
)
select
    t2.INDEX_NO_MCS as index_no_mcs                              --None
    ,t2.INDEX_NAME_MCS as index_name_mcs                         --None
    ,t3.org_id as org_no                                         --None
    ,t3.ORG_ABBR as org_name                                     --None
    ,sum(t2.INDEX_VALUE) as index_value                          --None
    -- 5
    ,t2.MEASURE_NO as measure_no                                 --None
    ,t2.INDEX_MEASURE as index_measure                           --None
    ,t2.CURR_NO as curr_no                                       --None
    ,t2.CURR_NAME as curr_name                                   --None
    ,to_date('${batch_date}','yyyymmdd') as etl_dt               --None
    -- 10
    ,TO_TIMESTAMP('${batch_timestamp}','yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp --None
 from tmp_mc_index_fact_jxkh_ind_result_2 t2 --None 
INNER JOIN mtl_cmm_intnal_org_info t3 --None 
 on substr(t2.org_no,1,3) = t3.org_id
   and t3.etl_dt = to_date('${batch_date}','yyyymmdd')

 
GROUP BY t2.INDEX_NO_MCS
,t2.INDEX_NAME_MCS
,t3.org_id
,t3.ORG_ABBR
,t2.MEASURE_NO
,t2.INDEX_MEASURE
,t2.CURR_NO
,t2.CURR_NAME
;
commit;


/*==============第19组==============*/

--指标结果表01:绩效报表产品筛选汇总-存贷款-全行汇总
insert into ${idl_schema}.tmp_mc_index_fact_jxkh_ind_result_1(
    index_no_mcs                                                 --指标编号_管驾
    ,index_name_mcs                                              --指标名称_管驾
    ,org_no                                                      --机构编号
    ,org_name                                                    --机构名称
    ,index_value                                                 --指标值
    -- 5
    ,measure_no                                                  --度量编号
    ,index_measure                                               --度量名称
    ,curr_no                                                     --币种代码
    ,curr_name                                                   --币种名称
    ,etl_dt                                                      --ETL处理日期
    -- 10
    ,etl_timestamp                                               --ETL处理时间戳
)
select
    t2.INDEX_NO_MCS as index_no_mcs                              --None
    ,t2.INDEX_NAME_MCS as index_name_mcs                         --None
    ,'000000' as org_no                                          --None
    ,'广东华兴银行 ' as org_name                                       --None
    ,sum(t2.INDEX_VALUE) as index_value                          --None
    -- 5
    ,t2.MEASURE_NO as measure_no                                 --None
    ,t2.INDEX_MEASURE as index_measure                           --None
    ,t2.CURR_NO as curr_no                                       --None
    ,t2.CURR_NAME as curr_name                                   --None
    ,to_date('${batch_date}','yyyymmdd') as etl_dt               --None
    -- 10
    ,TO_TIMESTAMP('${batch_timestamp}','yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp --None
 from tmp_mc_index_fact_jxkh_ind_result_2 t2 --None 

 
GROUP BY t2.INDEX_NO_MCS
,t2.INDEX_NAME_MCS
,t2.MEASURE_NO
,t2.INDEX_MEASURE
,t2.CURR_NO
,t2.CURR_NAME
;
commit;


/*==============第20组==============*/

--指标结果表01:管会指标表-不良资产率-支行
insert into ${idl_schema}.tmp_mc_index_fact_jxkh_ind_result_1(
    index_no_mcs                                                 --指标编号_管驾
    ,index_name_mcs                                              --指标名称_管驾
    ,org_no                                                      --机构编号
    ,org_name                                                    --机构名称
    ,index_value                                                 --指标值
    -- 5
    ,measure_no                                                  --度量编号
    ,index_measure                                               --度量名称
    ,curr_no                                                     --币种代码
    ,curr_name                                                   --币种名称
    ,etl_dt                                                      --ETL处理日期
    -- 10
    ,etl_timestamp                                               --ETL处理时间戳
)
select
    'JX010401058' as index_no_mcs                                --None
    ,'不良资产率' as index_name_mcs                                   --None
    ,t2.manager_org as org_no                                    --None
    ,t3.org_abbr as org_name                                     --None
    ,case when sum(t2.kpi_value_mom)=0 then 0 else sum(t2.kpi_value_mm)/sum(kpi_value_mom) end as index_value --None
    -- 5
    ,'001' as measure_no                                         --None
    ,'当前值' as index_measure                                      --None
    ,'BWB' as curr_no                                            --None
    ,'本外币合计' as curr_name                                        --None
    ,to_date('${batch_date}','yyyymmdd') as etl_dt               --None
    -- 10
    ,TO_TIMESTAMP('${batch_timestamp}','yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp --None
 from itl_edw_cass_r_rpt_rst0018 t2 --None 
INNER JOIN mtl_cmm_intnal_org_info t3 --None 
 on t2.manager_org = t3.org_id
   and t3.etl_dt = to_date('${batch_date}','yyyymmdd')

where t2.etl_dt=to_date('${batch_date}','yyyymmdd')
 and t2.index_name in ('零售不良资产率','公司不良资产率','同业不良资产率')
 and t2.manager_org<>'000000'
 and length(t2.manager_org)>3
GROUP BY t2.manager_org
,t3.org_abbr
;
commit;


/*==============第21组==============*/

--指标结果表01:管会指标表-不良资产率-分行
insert into ${idl_schema}.tmp_mc_index_fact_jxkh_ind_result_1(
    index_no_mcs                                                 --指标编号_管驾
    ,index_name_mcs                                              --指标名称_管驾
    ,org_no                                                      --机构编号
    ,org_name                                                    --机构名称
    ,index_value                                                 --指标值
    -- 5
    ,measure_no                                                  --度量编号
    ,index_measure                                               --度量名称
    ,curr_no                                                     --币种代码
    ,curr_name                                                   --币种名称
    ,etl_dt                                                      --ETL处理日期
    -- 10
    ,etl_timestamp                                               --ETL处理时间戳
)
select
    'JX010401058' as index_no_mcs                                --None
    ,'不良资产率' as index_name_mcs                                   --None
    ,substr(t2.manager_org,1,3) as org_no                        --None
    ,t3.org_abbr as org_name                                     --None
    ,case when sum(t2.kpi_value_mom)=0 then 0 else sum(t2.kpi_value_mm)/sum(kpi_value_mom) end as index_value --None
    -- 5
    ,'001' as measure_no                                         --None
    ,'当前值' as index_measure                                      --None
    ,'BWB' as curr_no                                            --None
    ,'本外币合计' as curr_name                                        --None
    ,to_date('${batch_date}','yyyymmdd') as etl_dt               --None
    -- 10
    ,TO_TIMESTAMP('${batch_timestamp}','yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp --None
 from itl_edw_cass_r_rpt_rst0018 t2 --None 
INNER JOIN mtl_cmm_intnal_org_info t3 --None 
 on substr(t2.manager_org,1,3) = t3.org_id
   and t3.etl_dt = to_date('${batch_date}','yyyymmdd')

where t2.etl_dt=to_date('${batch_date}','yyyymmdd')
 and t2.index_name in ('零售不良资产率','公司不良资产率','同业不良资产率')
 and t2.manager_org<>'000000'
GROUP BY substr(t2.manager_org,1,3)
,t3.org_abbr
;
commit;


/*==============第22组==============*/

--指标结果表01:管会指标表-不良资产率-全行
insert into ${idl_schema}.tmp_mc_index_fact_jxkh_ind_result_1(
    index_no_mcs                                                 --指标编号_管驾
    ,index_name_mcs                                              --指标名称_管驾
    ,org_no                                                      --机构编号
    ,org_name                                                    --机构名称
    ,index_value                                                 --指标值
    -- 5
    ,measure_no                                                  --度量编号
    ,index_measure                                               --度量名称
    ,curr_no                                                     --币种代码
    ,curr_name                                                   --币种名称
    ,etl_dt                                                      --ETL处理日期
    -- 10
    ,etl_timestamp                                               --ETL处理时间戳
)
select
    'JX010401058' as index_no_mcs                                --None
    ,'不良资产率' as index_name_mcs                                   --None
    ,'000000' as org_no                                          --None
    ,'广东华兴银行 ' as org_name                                       --None
    ,case when sum(t2.kpi_value_mom)=0 then 0 else sum(t2.kpi_value_mm)/sum(kpi_value_mom) end as index_value --None
    -- 5
    ,'001' as measure_no                                         --None
    ,'当前值' as index_measure                                      --None
    ,'BWB' as curr_no                                            --None
    ,'本外币合计' as curr_name                                        --None
    ,to_date('${batch_date}','yyyymmdd') as etl_dt               --None
    -- 10
    ,TO_TIMESTAMP('${batch_timestamp}','yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp --None
 from itl_edw_cass_r_rpt_rst0018 t2 --None 
INNER JOIN mtl_cmm_intnal_org_info t3 --None 
 on substr(t2.manager_org,1,3) = t3.org_id
   and t3.etl_dt = to_date('${batch_date}','yyyymmdd')

where t2.etl_dt=to_date('${batch_date}','yyyymmdd')
 and t2.index_name in ('零售不良资产率','公司不良资产率','同业不良资产率')
 
;
commit;


/*==============第23组==============*/

--指标结果表01:管会指标表-分指标-支行
insert into ${idl_schema}.tmp_mc_index_fact_jxkh_ind_result_1(
    index_no_mcs                                                 --指标编号_管驾
    ,index_name_mcs                                              --指标名称_管驾
    ,org_no                                                      --机构编号
    ,org_name                                                    --机构名称
    ,index_value                                                 --指标值
    -- 5
    ,measure_no                                                  --度量编号
    ,index_measure                                               --度量名称
    ,curr_no                                                     --币种代码
    ,curr_name                                                   --币种名称
    ,etl_dt                                                      --ETL处理日期
    -- 10
    ,etl_timestamp                                               --ETL处理时间戳
)
select
    t1.index_no_mcs as index_no_mcs                              --None
    ,t1.index_name_mcs as index_name_mcs                         --None
    ,t2.manager_org as org_no                                    --None
    ,t3.org_abbr as org_name                                     --None
    ,case when sum(t2.kpi_value_mom)=0 then 0 else sum(t2.kpi_value_mm)/sum(kpi_value_mom) end as index_value --None
    -- 5
    ,'001' as measure_no                                         --None
    ,'当前值' as index_measure                                      --None
    ,'BWB' as curr_no                                            --None
    ,'本外币合计' as curr_name                                        --None
    ,to_date('${batch_date}','yyyymmdd') as etl_dt               --None
    -- 10
    ,TO_TIMESTAMP('${batch_timestamp}','yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp --None
 from itl_edw_cass_r_rpt_rst0018 t2 --None 
INNER JOIN mtl_cmm_intnal_org_info t3 --None 
 on t2.manager_org = t3.org_id
   and t3.etl_dt = to_date('${batch_date}','yyyymmdd')
INNER JOIN mc_index_define t1 --None 
 on t1.index_name_mcs =t2.index_name
 and t1.etl_dt=to_date('20250429','yyyymmdd')--固定不改
 and t1.index_clsaa_f_mcs<>'盈利类'
 and t1.source_system='管理会计系统'

where t2.etl_dt=to_date('${batch_date}','yyyymmdd')
 and t2.manager_org<>'000000'
 and length(t2.manager_org)>3
GROUP BY t1.index_no_mcs
,t1.index_name_mcs
,t2.manager_org
,t3.org_abbr
;
commit;


/*==============第24组==============*/

--指标结果表01:管会指标表-分指标-分行
insert into ${idl_schema}.tmp_mc_index_fact_jxkh_ind_result_1(
    index_no_mcs                                                 --指标编号_管驾
    ,index_name_mcs                                              --指标名称_管驾
    ,org_no                                                      --机构编号
    ,org_name                                                    --机构名称
    ,index_value                                                 --指标值
    -- 5
    ,measure_no                                                  --度量编号
    ,index_measure                                               --度量名称
    ,curr_no                                                     --币种代码
    ,curr_name                                                   --币种名称
    ,etl_dt                                                      --ETL处理日期
    -- 10
    ,etl_timestamp                                               --ETL处理时间戳
)
select
    t1.index_no_mcs as index_no_mcs                              --None
    ,t1.index_name_mcs as index_name_mcs                         --None
    ,substr(t2.manager_org,1,3) as org_no                        --None
    ,t3.org_abbr as org_name                                     --None
    ,case when sum(t2.kpi_value_mom)=0 then 0 else sum(t2.kpi_value_mm)/sum(kpi_value_mom) end as index_value --None
    -- 5
    ,'001' as measure_no                                         --None
    ,'当前值' as index_measure                                      --None
    ,'BWB' as curr_no                                            --None
    ,'本外币合计' as curr_name                                        --None
    ,to_date('${batch_date}','yyyymmdd') as etl_dt               --None
    -- 10
    ,TO_TIMESTAMP('${batch_timestamp}','yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp --None
 from itl_edw_cass_r_rpt_rst0018 t2 --None 
INNER JOIN mtl_cmm_intnal_org_info t3 --None 
 on substr(t2.manager_org,1,3) = t3.org_id
   and t3.etl_dt = to_date('${batch_date}','yyyymmdd')
INNER JOIN mc_index_define t1 --None 
 on t1.index_name_mcs =t2.index_name
 and t1.etl_dt=to_date('20250429','yyyymmdd')--固定不改
 and t1.index_clsaa_f_mcs<>'盈利类'
 and t1.source_system='管理会计系统'

where t2.etl_dt=to_date('${batch_date}','yyyymmdd')
 and t2.manager_org<>'000000'
GROUP BY substr(t2.manager_org,1,3)
,t1.index_no_mcs
,t1.index_name_mcs
,t3.org_abbr
;
commit;


/*==============第25组==============*/

--指标结果表01:管会指标表-分指标-全行
insert into ${idl_schema}.tmp_mc_index_fact_jxkh_ind_result_1(
    index_no_mcs                                                 --指标编号_管驾
    ,index_name_mcs                                              --指标名称_管驾
    ,org_no                                                      --机构编号
    ,org_name                                                    --机构名称
    ,index_value                                                 --指标值
    -- 5
    ,measure_no                                                  --度量编号
    ,index_measure                                               --度量名称
    ,curr_no                                                     --币种代码
    ,curr_name                                                   --币种名称
    ,etl_dt                                                      --ETL处理日期
    -- 10
    ,etl_timestamp                                               --ETL处理时间戳
)
select
    t1.index_no_mcs as index_no_mcs                              --None
    ,t1.index_name_mcs as index_name_mcs                         --None
    ,'000000' as org_no                                          --None
    ,'广东华兴银行 ' as org_name                                       --None
    ,case when sum(t2.kpi_value_mom)=0 then 0 else sum(t2.kpi_value_mm)/sum(kpi_value_mom) end as index_value --None
    -- 5
    ,'001' as measure_no                                         --None
    ,'当前值' as index_measure                                      --None
    ,'BWB' as curr_no                                            --None
    ,'本外币合计' as curr_name                                        --None
    ,to_date('${batch_date}','yyyymmdd') as etl_dt               --None
    -- 10
    ,TO_TIMESTAMP('${batch_timestamp}','yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp --None
 from itl_edw_cass_r_rpt_rst0018 t2 --None 
INNER JOIN mtl_cmm_intnal_org_info t3 --None 
 on substr(t2.manager_org,1,3) = t3.org_id
   and t3.etl_dt = to_date('${batch_date}','yyyymmdd')
INNER JOIN mc_index_define t1 --None 
 on t1.index_name_mcs =t2.index_name
 and t1.etl_dt=to_date('20250429','yyyymmdd')--固定不改
 and t1.index_clsaa_f_mcs<>'盈利类'
 and t1.source_system='管理会计系统'

where t2.etl_dt=to_date('${batch_date}','yyyymmdd')
GROUP BY t1.index_no_mcs
,t1.index_name_mcs
;
commit;


/*==============第26组==============*/

--指标结果表01:管会指标表-取分子-支行
insert into ${idl_schema}.tmp_mc_index_fact_jxkh_ind_result_1(
    index_no_mcs                                                 --指标编号_管驾
    ,index_name_mcs                                              --指标名称_管驾
    ,org_no                                                      --机构编号
    ,org_name                                                    --机构名称
    ,index_value                                                 --指标值
    -- 5
    ,measure_no                                                  --度量编号
    ,index_measure                                               --度量名称
    ,curr_no                                                     --币种代码
    ,curr_name                                                   --币种名称
    ,etl_dt                                                      --ETL处理日期
    -- 10
    ,etl_timestamp                                               --ETL处理时间戳
)
select
    t1.index_no_mcs as index_no_mcs                              --None
    ,t1.index_name_mcs as index_name_mcs                         --None
    ,t2.manager_org as org_no                                    --None
    ,t3.org_abbr as org_name                                     --None
    ,sum(t2.kpi_value_mm) as index_value                         --None
    -- 5
    ,'001' as measure_no                                         --None
    ,'当前值' as index_measure                                      --None
    ,'BWB' as curr_no                                            --None
    ,'本外币合计' as curr_name                                        --None
    ,to_date('${batch_date}','yyyymmdd') as etl_dt               --None
    -- 10
    ,TO_TIMESTAMP('${batch_timestamp}','yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp --None
 from itl_edw_cass_r_rpt_rst0018 t2 --None 
INNER JOIN mtl_cmm_intnal_org_info t3 --None 
 on t2.manager_org = t3.org_id
   and t3.etl_dt = to_date('${batch_date}','yyyymmdd')
INNER JOIN mc_index_define t1 --None 
 on t2.index_name =replace(t1.index_name,'的分子','')
 and t1.etl_dt=to_date('20250429','yyyymmdd')--固定不改
 and t1.index_clsaa_f_mcs<>'盈利类'
 and t1.source_system='管理会计系统'
 and t1.index_name like '%分子%'

where t2.etl_dt=to_date('${batch_date}','yyyymmdd')
 and t2.manager_org<>'000000'
 and length(t2.manager_org)>3
GROUP BY t1.index_no_mcs
,t1.index_name_mcs
,t2.manager_org
,t3.org_abbr
;
commit;


/*==============第27组==============*/

--指标结果表01:管会指标表-取分子-分行
insert into ${idl_schema}.tmp_mc_index_fact_jxkh_ind_result_1(
    index_no_mcs                                                 --指标编号_管驾
    ,index_name_mcs                                              --指标名称_管驾
    ,org_no                                                      --机构编号
    ,org_name                                                    --机构名称
    ,index_value                                                 --指标值
    -- 5
    ,measure_no                                                  --度量编号
    ,index_measure                                               --度量名称
    ,curr_no                                                     --币种代码
    ,curr_name                                                   --币种名称
    ,etl_dt                                                      --ETL处理日期
    -- 10
    ,etl_timestamp                                               --ETL处理时间戳
)
select
    t1.index_no_mcs as index_no_mcs                              --None
    ,t1.index_name_mcs as index_name_mcs                         --None
    ,substr(t2.manager_org,1,3) as org_no                        --None
    ,t3.org_abbr as org_name                                     --None
    ,sum(t2.kpi_value_mm) as index_value                         --None
    -- 5
    ,'001' as measure_no                                         --None
    ,'当前值' as index_measure                                      --None
    ,'BWB' as curr_no                                            --None
    ,'本外币合计' as curr_name                                        --None
    ,to_date('${batch_date}','yyyymmdd') as etl_dt               --None
    -- 10
    ,TO_TIMESTAMP('${batch_timestamp}','yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp --None
 from itl_edw_cass_r_rpt_rst0018 t2 --None 
INNER JOIN mtl_cmm_intnal_org_info t3 --None 
 on substr(t2.manager_org,1,3) = t3.org_id
   and t3.etl_dt = to_date('${batch_date}','yyyymmdd')
INNER JOIN mc_index_define t1 --None 
 on t2.index_name =replace(t1.index_name,'的分子','')
 and t1.etl_dt=to_date('20250429','yyyymmdd')--固定不改
 and t1.index_clsaa_f_mcs<>'盈利类'
 and t1.source_system='管理会计系统'
 and t1.index_name like '%分子%'

where t2.etl_dt=to_date('${batch_date}','yyyymmdd')
 and t2.manager_org<>'000000'
GROUP BY substr(t2.manager_org,1,3)
,t1.index_no_mcs
,t1.index_name_mcs
,t3.org_abbr
;
commit;


/*==============第28组==============*/

--指标结果表01:管会指标表-取分子-全行
insert into ${idl_schema}.tmp_mc_index_fact_jxkh_ind_result_1(
    index_no_mcs                                                 --指标编号_管驾
    ,index_name_mcs                                              --指标名称_管驾
    ,org_no                                                      --机构编号
    ,org_name                                                    --机构名称
    ,index_value                                                 --指标值
    -- 5
    ,measure_no                                                  --度量编号
    ,index_measure                                               --度量名称
    ,curr_no                                                     --币种代码
    ,curr_name                                                   --币种名称
    ,etl_dt                                                      --ETL处理日期
    -- 10
    ,etl_timestamp                                               --ETL处理时间戳
)
select
    t1.index_no_mcs as index_no_mcs                              --None
    ,t1.index_name_mcs as index_name_mcs                         --None
    ,'000000' as org_no                                          --None
    ,'广东华兴银行 ' as org_name                                       --None
    ,sum(t2.kpi_value_mm) as index_value                         --None
    -- 5
    ,'001' as measure_no                                         --None
    ,'当前值' as index_measure                                      --None
    ,'BWB' as curr_no                                            --None
    ,'本外币合计' as curr_name                                        --None
    ,to_date('${batch_date}','yyyymmdd') as etl_dt               --None
    -- 10
    ,TO_TIMESTAMP('${batch_timestamp}','yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp --None
 from itl_edw_cass_r_rpt_rst0018 t2 --None 
INNER JOIN mtl_cmm_intnal_org_info t3 --None 
 on substr(t2.manager_org,1,3) = t3.org_id
   and t3.etl_dt = to_date('${batch_date}','yyyymmdd')
INNER JOIN mc_index_define t1 --None 
 on t2.index_name =replace(t1.index_name,'的分子','')
 and t1.etl_dt=to_date('20250429','yyyymmdd')--固定不改
 and t1.index_clsaa_f_mcs<>'盈利类'
 and t1.source_system='管理会计系统'
 and t1.index_name like '%分子%'

where t2.etl_dt=to_date('${batch_date}','yyyymmdd')
GROUP BY t1.index_no_mcs
,t1.index_name_mcs
;
commit;


/*==============第29组==============*/

--指标结果表03:绩效指标结果表-盈利类-2
whenever sqlerror continue none;
drop table ${idl_schema}.tmp_mc_index_fact_jxkh_ind_result_3 purge;
whenever sqlerror exit sql.sqlcode;
create table ${idl_schema}.tmp_mc_index_fact_jxkh_ind_result_3 (
    index_no_mcs varchar2(60)                                     --指标编号_管驾
    ,index_name_mcs varchar2(500) --指标名称_管驾
    ,org_no varchar2(60) --机构编号
    ,org_name varchar2(500) --机构名称
    ,accu_index_value_m number(38,8) --当月值
    -- 5
    ,accu_index_value_y number(38,8) --当年值
    ,measure_no varchar2(150) --度量编号
    ,index_measure varchar2(500) --度量名称
    ,curr_no varchar2(10) --币种代码
    ,curr_name varchar2(500) --币种名称
    -- 10
    ,etl_dt date --ETL处理日期
    ,etl_timestamp timestamp(6) --ETL处理时间戳
)
 ;

insert into ${idl_schema}.tmp_mc_index_fact_jxkh_ind_result_3(
    index_no_mcs                                                 --指标编号_管驾
    ,index_name_mcs                                              --指标名称_管驾
    ,org_no                                                      --机构编号
    ,org_name                                                    --机构名称
    ,accu_index_value_m                                          --当月值
    -- 5
    ,accu_index_value_y                                          --当年值
    ,measure_no                                                  --度量编号
    ,index_measure                                               --度量名称
    ,curr_no                                                     --币种代码
    ,curr_name                                                   --币种名称
    -- 10
    ,etl_dt                                                      --ETL处理日期
    ,etl_timestamp                                               --ETL处理时间戳
)
select
    t1.index_no_mcs as index_no_mcs                              --None
    ,t1.index_name_mcs as index_name_mcs                         --None
    ,t3.jgdh as org_no                                           --None
    ,t3.jgqc as org_name                                         --None
    ,sum(case when t2.sdbs ='5' then t2.zbz/(case when t1.unit='%' then 100 else 1 end) else 0 end) as accu_index_value_m --None
    -- 5
    ,sum(case when t2.sdbs ='7' then t2.zbz/(case when t1.unit='%' then 100 else 1 end) else 0 end) as accu_index_value_y --None
    ,'001' as measure_no                                         --None
    ,'当期值' as index_measure                                      --None
    ,decode(t2.bz,'01','CNY','0A','BWB','FF','BWB') as curr_no   --None
    ,decode(t2.bz,'01','人民币','0A','本外币合计','FF','本外币合计') as curr_name --None
    -- 10
    ,to_date('${batch_date}','yyyymmdd') as etl_dt               --None
    ,TO_TIMESTAMP('${batch_timestamp}','yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp --None
 from itl_edw_pams_v_yjzb_jg t2 --None 
INNER JOIN itl_edw_pams_khdx_jg t3 --None 
 on t3.khdxdh=t2.khdxdh
  and t3.etl_dt=to_date('${batch_date}','yyyymmdd')
INNER JOIN mc_index_define t1 --None 
 on to_char(t2.zbdh)=t1.index_no
 and t1.etl_dt=to_date('20250429','yyyymmdd')--固定不改
 and t1.index_clsaa_f_mcs='盈利类'
where t2.etl_dt=to_date('${batch_date}','yyyymmdd')
 and t2.tjrq='${batch_date}'
 and t2.tjkj='1' --统计口径：0-会计口径，1-考核口径
 and t2.sdbs in ('5','7')--指标时段：1-时点，2-月日均，3-季日均，4-年日均，5-月累计，6-季累计，7-年累计 
 and t2.bz in ('01','0A','FF')--币种：01-人民币，0A-本外币合计，0B-外币折人民币，0C-外币折美元，FF-非币种
GROUP BY t1.index_no_mcs
,t1.index_name_mcs
,t3.jgdh
,t3.jgqc
,decode(t2.bz,'01','CNY','0A','BWB','FF','BWB')
,decode(t2.bz,'01','人民币','0A','本外币合计','FF','本外币合计');
commit;


/*==============第30组==============*/

--指标结果表03:绩效指标结果表-盈利类-3.1
insert into ${idl_schema}.tmp_mc_index_fact_jxkh_ind_result_3(
    index_no_mcs                                                 --指标编号_管驾
    ,index_name_mcs                                              --指标名称_管驾
    ,org_no                                                      --机构编号
    ,org_name                                                    --机构名称
    ,accu_index_value_m                                          --当月值
    -- 5
    ,accu_index_value_y                                          --当年值
    ,measure_no                                                  --度量编号
    ,index_measure                                               --度量名称
    ,curr_no                                                     --币种代码
    ,curr_name                                                   --币种名称
    -- 10
    ,etl_dt                                                      --ETL处理日期
    ,etl_timestamp                                               --ETL处理时间戳
)
select
    'JX020302113' as index_no_mcs                                --None
    ,'非标资产收益率' as index_name_mcs                                 --None
    ,t3.jgdh as org_no                                           --None
    ,t3.jgqc as org_name                                         --None
    ,case
         when sum(case
                    when (t2.zbdh = 20001887 or t2.zbdh = 20001859)
                         and t2.sdbs = '2' then
                     nvl(t2.zbz, 0)
                    else
                     0
                  end) = 0 then
          0
         else
          sum(case
                when (t2.zbdh = 20001613 or t2.zbdh = 20001631 or t2.zbdh = 20001609 or t2.zbdh = 20001622)
                     and t2.sdbs = '5' then
                 nvl(t2.zbz, 0)
                else
                 0
              end) / sum(case
                           when (t2.zbdh = 20001887 or t2.zbdh = 20001859)
                                and t2.sdbs = '2' then
                            nvl(t2.zbz, 0)
                           else
                            0
                         end) * max(to_char(add_months(trunc(t2.etl_dt, 'YEAR'), 12) - 1, 'DDD')) / max(extract(day from t2.etl_dt))
       end as accu_index_value_m --None
    -- 5
    ,case
         when sum(case
                    when (t2.zbdh = 20001887 or t2.zbdh = 20001859)
                         and t2.sdbs = '4' then
                     nvl(t2.zbz, 0)
                    else
                     0
                  end) = 0 then
          0
         else
          sum(case
                when (t2.zbdh = 20001613 or t2.zbdh = 20001631 or t2.zbdh = 20001609 or t2.zbdh = 20001622)
                     and t2.sdbs = '7' then
                 nvl(t2.zbz, 0)
                else
                 0
              end) / sum(case
                           when (t2.zbdh = 20001887 or t2.zbdh = 20001859)
                                and t2.sdbs = '4' then
                            nvl(t2.zbz, 0)
                           else
                            0
                         end) * max(to_char(add_months(trunc(t2.etl_dt, 'YEAR'), 12) - 1, 'DDD')) / max(to_char(t2.etl_dt, 'DDD'))
       end as accu_index_value_y --None
    ,'001' as measure_no                                         --None
    ,'当期值' as index_measure                                      --None
    ,decode(t2.bz,'01','CNY','0A','BWB','FF','BWB') as curr_no   --None
    ,decode(t2.bz,'01','人民币','0A','本外币合计','FF','本外币合计') as curr_name --None
    -- 10
    ,to_date('${batch_date}','yyyymmdd') as etl_dt               --None
    ,TO_TIMESTAMP('${batch_timestamp}','yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp --None
 from itl_edw_pams_v_yjzb_jg t2 --None 
INNER JOIN itl_edw_pams_khdx_jg t3 --None 
 on t3.khdxdh=t2.khdxdh
  and t3.etl_dt=to_date('${batch_date}','yyyymmdd')

where t2.etl_dt=to_date('${batch_date}','yyyymmdd')
 and t2.tjrq='${batch_date}'
 and t2.tjkj='1' --统计口径：0-会计口径，1-考核口径
 --and t2.sdbs in ('1')--指标时段：1-时点，2-月日均，3-季日均，4-年日均，5-月累计，6-季累计，7-年累计 
 and t2.bz in ('01','0A','FF')--币种：01-人民币，0A-本外币合计，0B-外币折人民币，0C-外币折美元，FF-非币种
 and t2.zbdh in (20001613,20001631,20001609,20001622,20001887,20001859)
GROUP BY t3.jgdh
,t3.jgqc
,decode(t2.bz,'01','CNY','0A','BWB','FF','BWB')
,decode(t2.bz,'01','人民币','0A','本外币合计','FF','本外币合计');
commit;


/*==============第31组==============*/

--指标结果表03:绩效指标结果表-盈利类-3.2
insert into ${idl_schema}.tmp_mc_index_fact_jxkh_ind_result_3(
    index_no_mcs                                                 --指标编号_管驾
    ,index_name_mcs                                              --指标名称_管驾
    ,org_no                                                      --机构编号
    ,org_name                                                    --机构名称
    ,accu_index_value_m                                          --当月值
    -- 5
    ,accu_index_value_y                                          --当年值
    ,measure_no                                                  --度量编号
    ,index_measure                                               --度量名称
    ,curr_no                                                     --币种代码
    ,curr_name                                                   --币种名称
    -- 10
    ,etl_dt                                                      --ETL处理日期
    ,etl_timestamp                                               --ETL处理时间戳
)
select
    'JX020302114' as index_no_mcs                                --None
    ,'标准资产收益率' as index_name_mcs                                 --None
    ,t3.jgdh as org_no                                           --None
    ,t3.jgqc as org_name                                         --None
    ,case
         when sum(case
                    when (t2.zbdh = 20001833 or t2.zbdh = 20001847)
                         and t2.sdbs = '2' then
                     nvl(t2.zbz, 0)
                    else
                     0
                  end) = 0 then
          0
         else
          sum(case
                when (t2.zbdh = 20001568 or t2.zbdh = 20001572 or t2.zbdh = 20001593)
                     and t2.sdbs = '5' then
                 nvl(t2.zbz, 0)
                else
                 0
              end) / sum(case
                           when (t2.zbdh = 20001833 or t2.zbdh = 20001847)
                                and t2.sdbs = '2' then
                            nvl(t2.zbz, 0)
                           else
                            0
                         end) * max(to_char(add_months(trunc(t2.etl_dt, 'YEAR'), 12) - 1, 'DDD')) / max(extract(day from t2.etl_dt))
       end as accu_index_value_m --None
    -- 5
    ,case
         when sum(case
                    when (t2.zbdh = 20001833 or t2.zbdh = 20001847)
                         and t2.sdbs = '4' then
                     nvl(t2.zbz, 0)
                    else
                     0
                  end) = 0 then
          0
         else
          sum(case
                when (t2.zbdh = 20001568 or t2.zbdh = 20001572 or t2.zbdh = 20001593 )
                     and t2.sdbs = '7' then
                 nvl(t2.zbz, 0)
                else
                 0
              end) / sum(case
                           when (t2.zbdh = 20001833 or t2.zbdh = 20001847)
                                and t2.sdbs = '4' then
                            nvl(t2.zbz, 0)
                           else
                            0
                         end) * max(to_char(add_months(trunc(t2.etl_dt, 'YEAR'), 12) - 1, 'DDD')) / max(to_char(t2.etl_dt, 'DDD'))
       end as accu_index_value_y --None
    ,'001' as measure_no                                         --None
    ,'当期值' as index_measure                                      --None
    ,decode(t2.bz,'01','CNY','0A','BWB','FF','BWB') as curr_no   --None
    ,decode(t2.bz,'01','人民币','0A','本外币合计','FF','本外币合计') as curr_name --None
    -- 10
    ,to_date('${batch_date}','yyyymmdd') as etl_dt               --None
    ,TO_TIMESTAMP('${batch_timestamp}','yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp --None
 from itl_edw_pams_v_yjzb_jg t2 --None 
INNER JOIN itl_edw_pams_khdx_jg t3 --None 
 on t3.khdxdh=t2.khdxdh
  and t3.etl_dt=to_date('${batch_date}','yyyymmdd')

where t2.etl_dt=to_date('${batch_date}','yyyymmdd')
 and t2.tjrq='${batch_date}'
 and t2.tjkj='1' --统计口径：0-会计口径，1-考核口径
 --and t2.sdbs in ('1')--指标时段：1-时点，2-月日均，3-季日均，4-年日均，5-月累计，6-季累计，7-年累计 
 and t2.bz in ('01','0A','FF')--币种：01-人民币，0A-本外币合计，0B-外币折人民币，0C-外币折美元，FF-非币种
 and t2.zbdh in (20001568,20001572,20001593,20001833,20001847)
GROUP BY t3.jgdh
,t3.jgqc
,decode(t2.bz,'01','CNY','0A','BWB','FF','BWB')
,decode(t2.bz,'01','人民币','0A','本外币合计','FF','本外币合计');
commit;


/*==============第32组==============*/

--指标结果表03:绩效指标结果表-盈利类-3.3
insert into ${idl_schema}.tmp_mc_index_fact_jxkh_ind_result_3(
    index_no_mcs                                                 --指标编号_管驾
    ,index_name_mcs                                              --指标名称_管驾
    ,org_no                                                      --机构编号
    ,org_name                                                    --机构名称
    ,accu_index_value_m                                          --当月值
    -- 5
    ,accu_index_value_y                                          --当年值
    ,measure_no                                                  --度量编号
    ,index_measure                                               --度量名称
    ,curr_no                                                     --币种代码
    ,curr_name                                                   --币种名称
    -- 10
    ,etl_dt                                                      --ETL处理日期
    ,etl_timestamp                                               --ETL处理时间戳
)
select
    'JX020302115' as index_no_mcs                                --None
    ,'基金收益率' as index_name_mcs                                   --None
    ,t3.jgdh as org_no                                           --None
    ,t3.jgqc as org_name                                         --None
    ,case
         when sum(case
                    when (t2.zbdh = 20001854)
                         and t2.sdbs = '2' then
                     nvl(t2.zbz, 0)
                    else
                     0
                  end) = 0 then
          0
         else
          sum(case
                when (t2.zbdh = 20001597)
                     and t2.sdbs = '5' then
                 nvl(t2.zbz, 0)
                else
                 0
              end) / sum(case
                           when (t2.zbdh = 20001854)
                                and t2.sdbs = '2' then
                            nvl(t2.zbz, 0)
                           else
                            0
                         end) * max(to_char(add_months(trunc(t2.etl_dt, 'YEAR'), 12) - 1, 'DDD')) / max(extract(day from t2.etl_dt))
       end as accu_index_value_m --None
    -- 5
    ,case
         when sum(case
                    when (t2.zbdh = 20001854)
                         and t2.sdbs = '4' then
                     nvl(t2.zbz, 0)
                    else
                     0
                  end) = 0 then
          0
         else
          sum(case
                when (t2.zbdh = 20001597 )
                     and t2.sdbs = '7' then
                 nvl(t2.zbz, 0)
                else
                 0
              end) / sum(case
                           when (t2.zbdh = 20001854)
                                and t2.sdbs = '4' then
                            nvl(t2.zbz, 0)
                           else
                            0
                         end) * max(to_char(add_months(trunc(t2.etl_dt, 'YEAR'), 12) - 1, 'DDD')) / max(to_char(t2.etl_dt, 'DDD'))
       end as accu_index_value_y --None
    ,'001' as measure_no                                         --None
    ,'当期值' as index_measure                                      --None
    ,decode(t2.bz,'01','CNY','0A','BWB','FF','BWB') as curr_no   --None
    ,decode(t2.bz,'01','人民币','0A','本外币合计','FF','本外币合计') as curr_name --None
    -- 10
    ,to_date('${batch_date}','yyyymmdd') as etl_dt               --None
    ,TO_TIMESTAMP('${batch_timestamp}','yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp --None
 from itl_edw_pams_v_yjzb_jg t2 --None 
INNER JOIN itl_edw_pams_khdx_jg t3 --None 
 on t3.khdxdh=t2.khdxdh
  and t3.etl_dt=to_date('${batch_date}','yyyymmdd')

where t2.etl_dt=to_date('${batch_date}','yyyymmdd')
 and t2.tjrq='${batch_date}'
 and t2.tjkj='1' --统计口径：0-会计口径，1-考核口径
 --and t2.sdbs in ('1')--指标时段：1-时点，2-月日均，3-季日均，4-年日均，5-月累计，6-季累计，7-年累计 
 and t2.bz in ('01','0A','FF')--币种：01-人民币，0A-本外币合计，0B-外币折人民币，0C-外币折美元，FF-非币种
 and t2.zbdh in (20001597,20001854)
GROUP BY t3.jgdh
,t3.jgqc
,decode(t2.bz,'01','CNY','0A','BWB','FF','BWB')
,decode(t2.bz,'01','人民币','0A','本外币合计','FF','本外币合计');
commit;


/*==============第33组==============*/

--指标结果表03:绩效指标结果表-盈利类-3.4
insert into ${idl_schema}.tmp_mc_index_fact_jxkh_ind_result_3(
    index_no_mcs                                                 --指标编号_管驾
    ,index_name_mcs                                              --指标名称_管驾
    ,org_no                                                      --机构编号
    ,org_name                                                    --机构名称
    ,accu_index_value_m                                          --当月值
    -- 5
    ,accu_index_value_y                                          --当年值
    ,measure_no                                                  --度量编号
    ,index_measure                                               --度量名称
    ,curr_no                                                     --币种代码
    ,curr_name                                                   --币种名称
    -- 10
    ,etl_dt                                                      --ETL处理日期
    ,etl_timestamp                                               --ETL处理时间戳
)
select
    'JX020302116' as index_no_mcs                                --None
    ,'同业往来收益率' as index_name_mcs                                 --None
    ,t3.jgdh as org_no                                           --None
    ,t3.jgqc as org_name                                         --None
    ,case
         when sum(case
                    when t2.zbdh = 20002946 and t2.sdbs = '2' then
                     nvl(t2.zbz, 0)
                    else
                     0
                  end) -sum(case
                    when t2.zbdh = 2000184 and t2.sdbs = '2' then
                     nvl(t2.zbz, 0)
                    else
                     0
                  end)=0 then
          0
         else
          sum(case
                when (t2.zbdh = 20001602 or t2.zbdh =20001607 or t2.zbdh =20001635 )
                     and t2.sdbs = '5' then
                 nvl(t2.zbz, 0)
                else
                 0
              end) / sum(case
                    when t2.zbdh = 20002946 and t2.sdbs = '2' then
                     nvl(t2.zbz, 0)
                    else
                     0
                  end) -sum(case
                    when t2.zbdh = 2000184 and t2.sdbs = '2' then
                     nvl(t2.zbz, 0)
                    else
                     0
                  end) * max(to_char(add_months(trunc(t2.etl_dt, 'YEAR'), 12) - 1, 'DDD')) / max(extract(day from t2.etl_dt))
       end as accu_index_value_m --None
    -- 5
    ,case
         when sum(case
                    when t2.zbdh = 20002946 and t2.sdbs = '4' then
                     nvl(t2.zbz, 0)
                    else
                     0
                  end) -sum(case
                    when t2.zbdh = 2000184 and t2.sdbs = '4' then
                     nvl(t2.zbz, 0)
                    else
                     0
                  end)=0 then
          0
         else
          sum(case
                when (t2.zbdh = 20001602 or t2.zbdh =20001607 or t2.zbdh =20001635 )
                     and t2.sdbs = '7' then
                 nvl(t2.zbz, 0)
                else
                 0
              end) / sum(case
                    when t2.zbdh = 20002946 and t2.sdbs = '4' then
                     nvl(t2.zbz, 0)
                    else
                     0
                  end) -sum(case
                    when t2.zbdh = 2000184 and t2.sdbs = '4' then
                     nvl(t2.zbz, 0)
                    else
                     0
                  end) * max(to_char(add_months(trunc(t2.etl_dt, 'YEAR'), 12) - 1, 'DDD')) / max(to_char(t2.etl_dt, 'DDD'))
       end as accu_index_value_y --None
    ,'001' as measure_no                                         --None
    ,'当期值' as index_measure                                      --None
    ,decode(t2.bz,'01','CNY','0A','BWB','FF','BWB') as curr_no   --None
    ,decode(t2.bz,'01','人民币','0A','本外币合计','FF','本外币合计') as curr_name --None
    -- 10
    ,to_date('${batch_date}','yyyymmdd') as etl_dt               --None
    ,TO_TIMESTAMP('${batch_timestamp}','yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp --None
 from itl_edw_pams_v_yjzb_jg t2 --None 
INNER JOIN itl_edw_pams_khdx_jg t3 --None 
 on t3.khdxdh=t2.khdxdh
  and t3.etl_dt=to_date('${batch_date}','yyyymmdd')

where t2.etl_dt=to_date('${batch_date}','yyyymmdd')
 and t2.tjrq='${batch_date}'
 and t2.tjkj='1' --统计口径：0-会计口径，1-考核口径
 --and t2.sdbs in ('1')--指标时段：1-时点，2-月日均，3-季日均，4-年日均，5-月累计，6-季累计，7-年累计 
 and t2.bz in ('01','0A','FF')--币种：01-人民币，0A-本外币合计，0B-外币折人民币，0C-外币折美元，FF-非币种
 and t2.zbdh in (20001602,20001607,20001635,20002946,20001847)
GROUP BY t3.jgdh
,t3.jgqc
,decode(t2.bz,'01','CNY','0A','BWB','FF','BWB')
,decode(t2.bz,'01','人民币','0A','本外币合计','FF','本外币合计');
commit;


/*==============第34组==============*/

--指标结果表03:绩效指标结果表-盈利类-3.5
insert into ${idl_schema}.tmp_mc_index_fact_jxkh_ind_result_3(
    index_no_mcs                                                 --指标编号_管驾
    ,index_name_mcs                                              --指标名称_管驾
    ,org_no                                                      --机构编号
    ,org_name                                                    --机构名称
    ,accu_index_value_m                                          --当月值
    -- 5
    ,accu_index_value_y                                          --当年值
    ,measure_no                                                  --度量编号
    ,index_measure                                               --度量名称
    ,curr_no                                                     --币种代码
    ,curr_name                                                   --币种名称
    -- 10
    ,etl_dt                                                      --ETL处理日期
    ,etl_timestamp                                               --ETL处理时间戳
)
select
    'JX020501125' as index_no_mcs                                --None
    ,'营业净收入（FTP营业净收入）' as index_name_mcs                         --None
    ,t3.jgdh as org_no                                           --None
    ,t3.jgqc as org_name                                         --None
    ,sum(case when t2.sdbs ='5' then t2.zbz else 0 end) as accu_index_value_m --None
    -- 5
    ,sum(case when t2.sdbs ='7' then t2.zbz else 0 end) as accu_index_value_y --None
    ,'001' as measure_no                                         --None
    ,'当期值' as index_measure                                      --None
    ,decode(t2.bz,'01','CNY','0A','BWB','FF','BWB') as curr_no   --None
    ,decode(t2.bz,'01','人民币','0A','本外币合计','FF','本外币合计') as curr_name --None
    -- 10
    ,to_date('${batch_date}','yyyymmdd') as etl_dt               --None
    ,TO_TIMESTAMP('${batch_timestamp}','yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp --None
 from itl_edw_pams_v_yjzb_jg t2 --None 
INNER JOIN itl_edw_pams_khdx_jg t3 --None 
 on t3.khdxdh=t2.khdxdh
  and t3.etl_dt=to_date('${batch_date}','yyyymmdd')
  and t3.jgdh<>'000000'

where t2.etl_dt=to_date('${batch_date}','yyyymmdd')
 and t2.tjrq='${batch_date}'
 and t2.tjkj='1' --统计口径：0-会计口径，1-考核口径
 and t2.sdbs in ('5','7')--指标时段：1-时点，2-月日均，3-季日均，4-年日均，5-月累计，6-季累计，7-年累计 
 and t2.bz in ('01','0A','FF')--币种：01-人民币，0A-本外币合计，0B-外币折人民币，0C-外币折美元，FF-非币种
 and t2.zbdh =29500148
GROUP BY t3.jgdh
,t3.jgqc
,decode(t2.bz,'01','CNY','0A','BWB','FF','BWB')
,decode(t2.bz,'01','人民币','0A','本外币合计','FF','本外币合计');
commit;


/*==============第35组==============*/

--指标结果表03:绩效指标结果表-盈利类-3.6
insert into ${idl_schema}.tmp_mc_index_fact_jxkh_ind_result_3(
    index_no_mcs                                                 --指标编号_管驾
    ,index_name_mcs                                              --指标名称_管驾
    ,org_no                                                      --机构编号
    ,org_name                                                    --机构名称
    ,accu_index_value_m                                          --当月值
    -- 5
    ,accu_index_value_y                                          --当年值
    ,measure_no                                                  --度量编号
    ,index_measure                                               --度量名称
    ,curr_no                                                     --币种代码
    ,curr_name                                                   --币种名称
    -- 10
    ,etl_dt                                                      --ETL处理日期
    ,etl_timestamp                                               --ETL处理时间戳
)
select
    'JX020503145' as index_no_mcs                                --None
    ,'非利息净收入' as index_name_mcs                                  --None
    ,t3.jgdh as org_no                                           --None
    ,t3.jgqc as org_name                                         --None
    ,sum(case when t2.sdbs ='5'and t2.zbdh in (1000069,1000068,29500154,1000119,29501143) then 0-nvl(t2.zbz,0)
         when t2.sdbs ='5'and t2.zbdh in (1000036) then nvl(t2.zbz,0) else 0 end) as accu_index_value_m --None
    -- 5
    ,sum(case when t2.sdbs ='7'and t2.zbdh in (1000069,1000068,29500154,1000119,29501143) then 0-nvl(t2.zbz,0)
         when t2.sdbs ='7'and t2.zbdh in (1000036) then nvl(t2.zbz,0) else 0 end) as accu_index_value_y --None
    ,'001' as measure_no                                         --None
    ,'当期值' as index_measure                                      --None
    ,decode(t2.bz,'01','CNY','0A','BWB','FF','BWB') as curr_no   --None
    ,decode(t2.bz,'01','人民币','0A','本外币合计','FF','本外币合计') as curr_name --None
    -- 10
    ,to_date('${batch_date}','yyyymmdd') as etl_dt               --None
    ,TO_TIMESTAMP('${batch_timestamp}','yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp --None
 from itl_edw_pams_v_yjzb_jg t2 --None 
INNER JOIN itl_edw_pams_khdx_jg t3 --None 
 on t3.khdxdh=t2.khdxdh
  and t3.etl_dt=to_date('${batch_date}','yyyymmdd')

where t2.etl_dt=to_date('${batch_date}','yyyymmdd')
 and t2.tjrq='${batch_date}'
 and t2.tjkj='1' --统计口径：0-会计口径，1-考核口径
 and t2.sdbs in ('5','7')--指标时段：1-时点，2-月日均，3-季日均，4-年日均，5-月累计，6-季累计，7-年累计 
 and t2.bz in ('01','0A','FF')--币种：01-人民币，0A-本外币合计，0B-外币折人民币，0C-外币折美元，FF-非币种
 and t2.zbdh in(1000036,1000069,1000068,29500154,1000119,29501143)
GROUP BY t3.jgdh
,t3.jgqc
,decode(t2.bz,'01','CNY','0A','BWB','FF','BWB')
,decode(t2.bz,'01','人民币','0A','本外币合计','FF','本外币合计');
commit;


/*==============第36组==============*/

--指标结果表03:绩效指标结果表-盈利类-3.6
insert into ${idl_schema}.tmp_mc_index_fact_jxkh_ind_result_3(
    index_no_mcs                                                 --指标编号_管驾
    ,index_name_mcs                                              --指标名称_管驾
    ,org_no                                                      --机构编号
    ,org_name                                                    --机构名称
    ,accu_index_value_m                                          --当月值
    -- 5
    ,accu_index_value_y                                          --当年值
    ,measure_no                                                  --度量编号
    ,index_measure                                               --度量名称
    ,curr_no                                                     --币种代码
    ,curr_name                                                   --币种名称
    -- 10
    ,etl_dt                                                      --ETL处理日期
    ,etl_timestamp                                               --ETL处理时间戳
)
select
    'JX020504128' as index_no_mcs                                --None
    ,'存款FTP收入' as index_name_mcs                                 --None
    ,t3.jgdh as org_no                                           --None
    ,t3.jgqc as org_name                                         --None
    ,sum(case when t2.sdbs ='5'and t2.zbdh in (29500156,29501074) then 0-nvl(t2.zbz,0)
         when t2.sdbs ='5'and t2.zbdh in (2000874) then nvl(t2.zbz,0) else 0 end) as accu_index_value_m --None
    -- 5
    ,sum(case when t2.sdbs ='7'and t2.zbdh in (29500156,29501074) then 0-nvl(t2.zbz,0)
         when t2.sdbs ='7'and t2.zbdh in (2000874) then nvl(t2.zbz,0) else 0 end) as accu_index_value_y --None
    ,'001' as measure_no                                         --None
    ,'当期值' as index_measure                                      --None
    ,decode(t2.bz,'01','CNY','0A','BWB','FF','BWB') as curr_no   --None
    ,decode(t2.bz,'01','人民币','0A','本外币合计','FF','本外币合计') as curr_name --None
    -- 10
    ,to_date('${batch_date}','yyyymmdd') as etl_dt               --None
    ,TO_TIMESTAMP('${batch_timestamp}','yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp --None
 from itl_edw_pams_v_yjzb_jg t2 --None 
INNER JOIN itl_edw_pams_khdx_jg t3 --None 
 on t3.khdxdh=t2.khdxdh
  and t3.etl_dt=to_date('${batch_date}','yyyymmdd')

where t2.etl_dt=to_date('${batch_date}','yyyymmdd')
 and t2.tjrq='${batch_date}'
 and t2.tjkj='1' --统计口径：0-会计口径，1-考核口径
 and t2.sdbs in ('5','7')--指标时段：1-时点，2-月日均，3-季日均，4-年日均，5-月累计，6-季累计，7-年累计 
 and t2.bz in ('01','0A','FF')--币种：01-人民币，0A-本外币合计，0B-外币折人民币，0C-外币折美元，FF-非币种
 and t2.zbdh in(2000874,29500156,29501074)
GROUP BY t3.jgdh
,t3.jgqc
,decode(t2.bz,'01','CNY','0A','BWB','FF','BWB')
,decode(t2.bz,'01','人民币','0A','本外币合计','FF','本外币合计');
commit;


/*==============第37组==============*/

--指标结果表03:绩效指标结果表-盈利类-3.6
insert into ${idl_schema}.tmp_mc_index_fact_jxkh_ind_result_3(
    index_no_mcs                                                 --指标编号_管驾
    ,index_name_mcs                                              --指标名称_管驾
    ,org_no                                                      --机构编号
    ,org_name                                                    --机构名称
    ,accu_index_value_m                                          --当月值
    -- 5
    ,accu_index_value_y                                          --当年值
    ,measure_no                                                  --度量编号
    ,index_measure                                               --度量名称
    ,curr_no                                                     --币种代码
    ,curr_name                                                   --币种名称
    -- 10
    ,etl_dt                                                      --ETL处理日期
    ,etl_timestamp                                               --ETL处理时间戳
)
select
    'JX020503134' as index_no_mcs                                --None
    ,'贷款FTP净收入' as index_name_mcs                                --None
    ,t3.jgdh as org_no                                           --None
    ,t3.jgqc as org_name                                         --None
    ,sum(case when t2.sdbs ='5' then nvl(t2.zbz,0) else 0 end) as accu_index_value_m --None
    -- 5
    ,sum(case when t2.sdbs ='7' then nvl(t2.zbz,0) else 0 end) as accu_index_value_y --None
    ,'001' as measure_no                                         --None
    ,'当期值' as index_measure                                      --None
    ,decode(t2.bz,'01','CNY','0A','BWB','FF','BWB') as curr_no   --None
    ,decode(t2.bz,'01','人民币','0A','本外币合计','FF','本外币合计') as curr_name --None
    -- 10
    ,to_date('${batch_date}','yyyymmdd') as etl_dt               --None
    ,TO_TIMESTAMP('${batch_timestamp}','yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp --None
 from itl_edw_pams_v_yjzb_jg t2 --None 
INNER JOIN itl_edw_pams_khdx_jg t3 --None 
 on t3.khdxdh=t2.khdxdh
  and t3.etl_dt=to_date('${batch_date}','yyyymmdd')

where t2.etl_dt=to_date('${batch_date}','yyyymmdd')
 and t2.tjrq='${batch_date}'
 and t2.tjkj='1' --统计口径：0-会计口径，1-考核口径
 and t2.sdbs in ('5','7')--指标时段：1-时点，2-月日均，3-季日均，4-年日均，5-月累计，6-季累计，7-年累计 
 and t2.bz in ('01','0A','FF')--币种：01-人民币，0A-本外币合计，0B-外币折人民币，0C-外币折美元，FF-非币种
 and t2.zbdh in(1000068,29500154)
GROUP BY t3.jgdh
,t3.jgqc
,decode(t2.bz,'01','CNY','0A','BWB','FF','BWB')
,decode(t2.bz,'01','人民币','0A','本外币合计','FF','本外币合计');
commit;


/*==============第38组==============*/

--指标结果表03:绩效指标结果表-盈利类-3.6
insert into ${idl_schema}.tmp_mc_index_fact_jxkh_ind_result_3(
    index_no_mcs                                                 --指标编号_管驾
    ,index_name_mcs                                              --指标名称_管驾
    ,org_no                                                      --机构编号
    ,org_name                                                    --机构名称
    ,accu_index_value_m                                          --当月值
    -- 5
    ,accu_index_value_y                                          --当年值
    ,measure_no                                                  --度量编号
    ,index_measure                                               --度量名称
    ,curr_no                                                     --币种代码
    ,curr_name                                                   --币种名称
    -- 10
    ,etl_dt                                                      --ETL处理日期
    ,etl_timestamp                                               --ETL处理时间戳
)
select
    'JX020504135' as index_no_mcs                                --None
    ,'贷款利息收入' as index_name_mcs                                  --None
    ,t3.jgdh as org_no                                           --None
    ,t3.jgqc as org_name                                         --None
    ,sum(case when t2.sdbs ='5' then nvl(t2.zbz,0) else 0 end) as accu_index_value_m --None
    -- 5
    ,sum(case when t2.sdbs ='7' then nvl(t2.zbz,0) else 0 end) as accu_index_value_y --None
    ,'001' as measure_no                                         --None
    ,'当期值' as index_measure                                      --None
    ,decode(t2.bz,'01','CNY','0A','BWB','FF','BWB') as curr_no   --None
    ,decode(t2.bz,'01','人民币','0A','本外币合计','FF','本外币合计') as curr_name --None
    -- 10
    ,to_date('${batch_date}','yyyymmdd') as etl_dt               --None
    ,TO_TIMESTAMP('${batch_timestamp}','yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp --None
 from itl_edw_pams_v_yjzb_jg t2 --None 
INNER JOIN itl_edw_pams_khdx_jg t3 --None 
 on t3.khdxdh=t2.khdxdh
  and t3.etl_dt=to_date('${batch_date}','yyyymmdd')

where t2.etl_dt=to_date('${batch_date}','yyyymmdd')
 and t2.tjrq='${batch_date}'
 and t2.tjkj='1' --统计口径：0-会计口径，1-考核口径
 and t2.sdbs in ('5','7')--指标时段：1-时点，2-月日均，3-季日均，4-年日均，5-月累计，6-季累计，7-年累计 
 and t2.bz in ('01','0A','FF')--币种：01-人民币，0A-本外币合计，0B-外币折人民币，0C-外币折美元，FF-非币种
 and t2.zbdh in(2000894,29500154,2001021)
GROUP BY t3.jgdh
,t3.jgqc
,decode(t2.bz,'01','CNY','0A','BWB','FF','BWB')
,decode(t2.bz,'01','人民币','0A','本外币合计','FF','本外币合计');
commit;


/*==============第39组==============*/

--指标结果表03:绩效指标结果表-盈利类-3.6
insert into ${idl_schema}.tmp_mc_index_fact_jxkh_ind_result_3(
    index_no_mcs                                                 --指标编号_管驾
    ,index_name_mcs                                              --指标名称_管驾
    ,org_no                                                      --机构编号
    ,org_name                                                    --机构名称
    ,accu_index_value_m                                          --当月值
    -- 5
    ,accu_index_value_y                                          --当年值
    ,measure_no                                                  --度量编号
    ,index_measure                                               --度量名称
    ,curr_no                                                     --币种代码
    ,curr_name                                                   --币种名称
    -- 10
    ,etl_dt                                                      --ETL处理日期
    ,etl_timestamp                                               --ETL处理时间戳
)
select
    'JX020504136' as index_no_mcs                                --None
    ,'贷款FTP支出' as index_name_mcs                                 --None
    ,t3.jgdh as org_no                                           --None
    ,t3.jgqc as org_name                                         --None
    ,sum(case when t2.sdbs ='5' then nvl(t2.zbz,0) else 0 end) as accu_index_value_m --None
    -- 5
    ,sum(case when t2.sdbs ='7' then nvl(t2.zbz,0) else 0 end) as accu_index_value_y --None
    ,'001' as measure_no                                         --None
    ,'当期值' as index_measure                                      --None
    ,decode(t2.bz,'01','CNY','0A','BWB','FF','BWB') as curr_no   --None
    ,decode(t2.bz,'01','人民币','0A','本外币合计','FF','本外币合计') as curr_name --None
    -- 10
    ,to_date('${batch_date}','yyyymmdd') as etl_dt               --None
    ,TO_TIMESTAMP('${batch_timestamp}','yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp --None
 from itl_edw_pams_v_yjzb_jg t2 --None 
INNER JOIN itl_edw_pams_khdx_jg t3 --None 
 on t3.khdxdh=t2.khdxdh
  and t3.etl_dt=to_date('${batch_date}','yyyymmdd')

where t2.etl_dt=to_date('${batch_date}','yyyymmdd')
 and t2.tjrq='${batch_date}'
 and t2.tjkj='1' --统计口径：0-会计口径，1-考核口径
 and t2.sdbs in ('5','7')--指标时段：1-时点，2-月日均，3-季日均，4-年日均，5-月累计，6-季累计，7-年累计 
 and t2.bz in ('01','0A','FF')--币种：01-人民币，0A-本外币合计，0B-外币折人民币，0C-外币折美元，FF-非币种
 and t2.zbdh in(2000896,2001022)
GROUP BY t3.jgdh
,t3.jgqc
,decode(t2.bz,'01','CNY','0A','BWB','FF','BWB')
,decode(t2.bz,'01','人民币','0A','本外币合计','FF','本外币合计');
commit;


/*==============第40组==============*/

--指标结果表03:绩效指标结果表-盈利类-3.6
insert into ${idl_schema}.tmp_mc_index_fact_jxkh_ind_result_3(
    index_no_mcs                                                 --指标编号_管驾
    ,index_name_mcs                                              --指标名称_管驾
    ,org_no                                                      --机构编号
    ,org_name                                                    --机构名称
    ,accu_index_value_m                                          --当月值
    -- 5
    ,accu_index_value_y                                          --当年值
    ,measure_no                                                  --度量编号
    ,index_measure                                               --度量名称
    ,curr_no                                                     --币种代码
    ,curr_name                                                   --币种名称
    -- 10
    ,etl_dt                                                      --ETL处理日期
    ,etl_timestamp                                               --ETL处理时间戳
)
select
    'JX020504143' as index_no_mcs                                --None
    ,'类信贷业务收入' as index_name_mcs                                 --None
    ,t3.jgdh as org_no                                           --None
    ,t3.jgqc as org_name                                         --None
    ,sum(case when t2.sdbs ='5'and t2.zbdh in (2000828) then 0-nvl(t2.zbz,0)
         when t2.sdbs ='5'and t2.zbdh in (1000119) then nvl(t2.zbz,0) else 0 end) as accu_index_value_m --None
    -- 5
    ,sum(case when t2.sdbs ='7'and t2.zbdh in (2000828) then 0-nvl(t2.zbz,0)
         when t2.sdbs ='7'and t2.zbdh in (1000119) then nvl(t2.zbz,0) else 0 end) as accu_index_value_y --None
    ,'001' as measure_no                                         --None
    ,'当期值' as index_measure                                      --None
    ,decode(t2.bz,'01','CNY','0A','BWB','FF','BWB') as curr_no   --None
    ,decode(t2.bz,'01','人民币','0A','本外币合计','FF','本外币合计') as curr_name --None
    -- 10
    ,to_date('${batch_date}','yyyymmdd') as etl_dt               --None
    ,TO_TIMESTAMP('${batch_timestamp}','yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp --None
 from itl_edw_pams_v_yjzb_jg t2 --None 
INNER JOIN itl_edw_pams_khdx_jg t3 --None 
 on t3.khdxdh=t2.khdxdh
  and t3.etl_dt=to_date('${batch_date}','yyyymmdd')

where t2.etl_dt=to_date('${batch_date}','yyyymmdd')
 and t2.tjrq='${batch_date}'
 and t2.tjkj='1' --统计口径：0-会计口径，1-考核口径
 and t2.sdbs in ('5','7')--指标时段：1-时点，2-月日均，3-季日均，4-年日均，5-月累计，6-季累计，7-年累计 
 and t2.bz in ('01','0A','FF')--币种：01-人民币，0A-本外币合计，0B-外币折人民币，0C-外币折美元，FF-非币种
 and t2.zbdh in(1000119,2000828)
GROUP BY t3.jgdh
,t3.jgqc
,decode(t2.bz,'01','CNY','0A','BWB','FF','BWB')
,decode(t2.bz,'01','人民币','0A','本外币合计','FF','本外币合计');
commit;


/*==============第41组==============*/

--指标结果表03:绩效指标结果表-盈利类-3.6
insert into ${idl_schema}.tmp_mc_index_fact_jxkh_ind_result_3(
    index_no_mcs                                                 --指标编号_管驾
    ,index_name_mcs                                              --指标名称_管驾
    ,org_no                                                      --机构编号
    ,org_name                                                    --机构名称
    ,accu_index_value_m                                          --当月值
    -- 5
    ,accu_index_value_y                                          --当年值
    ,measure_no                                                  --度量编号
    ,index_measure                                               --度量名称
    ,curr_no                                                     --币种代码
    ,curr_name                                                   --币种名称
    -- 10
    ,etl_dt                                                      --ETL处理日期
    ,etl_timestamp                                               --ETL处理时间戳
)
select
    'JX020503164' as index_no_mcs                                --None
    ,'中间业务收入' as index_name_mcs                                  --None
    ,t3.jgdh as org_no                                           --None
    ,t3.jgqc as org_name                                         --None
    ,sum(case when t2.sdbs ='5' then nvl(t2.zbz,0) else 0 end) as accu_index_value_m --None
    -- 5
    ,sum(case when t2.sdbs ='7' then nvl(t2.zbz,0) else 0 end) as accu_index_value_y --None
    ,'001' as measure_no                                         --None
    ,'当期值' as index_measure                                      --None
    ,decode(t2.bz,'01','CNY','0A','BWB','FF','BWB') as curr_no   --None
    ,decode(t2.bz,'01','人民币','0A','本外币合计','FF','本外币合计') as curr_name --None
    -- 10
    ,to_date('${batch_date}','yyyymmdd') as etl_dt               --None
    ,TO_TIMESTAMP('${batch_timestamp}','yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp --None
 from itl_edw_pams_v_yjzb_jg t2 --None 
INNER JOIN itl_edw_pams_khdx_jg t3 --None 
 on t3.khdxdh=t2.khdxdh
  and t3.etl_dt=to_date('${batch_date}','yyyymmdd')

where t2.etl_dt=to_date('${batch_date}','yyyymmdd')
 and t2.tjrq='${batch_date}'
 and t2.tjkj='1' --统计口径：0-会计口径，1-考核口径
 and t2.sdbs in ('5','7')--指标时段：1-时点，2-月日均，3-季日均，4-年日均，5-月累计，6-季累计，7-年累计 
 and t2.bz in ('01','0A','FF')--币种：01-人民币，0A-本外币合计，0B-外币折人民币，0C-外币折美元，FF-非币种
 and t2.zbdh in(1000034,29500912)
GROUP BY t3.jgdh
,t3.jgqc
,decode(t2.bz,'01','CNY','0A','BWB','FF','BWB')
,decode(t2.bz,'01','人民币','0A','本外币合计','FF','本外币合计');
commit;


/*==============第42组==============*/

--指标结果表03:财务集市指标结果表-盈利类
insert into ${idl_schema}.tmp_mc_index_fact_jxkh_ind_result_3(
    index_no_mcs                                                 --指标编号_管驾
    ,index_name_mcs                                              --指标名称_管驾
    ,org_no                                                      --机构编号
    ,org_name                                                    --机构名称
    ,accu_index_value_m                                          --当月值
    -- 5
    ,accu_index_value_y                                          --当年值
    ,measure_no                                                  --度量编号
    ,index_measure                                               --度量名称
    ,curr_no                                                     --币种代码
    ,curr_name                                                   --币种名称
    -- 10
    ,etl_dt                                                      --ETL处理日期
    ,etl_timestamp                                               --ETL处理时间戳
)
select
    t1.index_no_mcs as index_no_mcs                              --None
    ,t1.index_name_mcs as index_name_mcs                         --None
    ,t2.org_no as org_no                                         --None
    ,t3.org_abbr as org_name                                     --None
    ,sum(case when t2.INDEX_MEASURE ='013' and t1.unit='%' then t2.index_val 
         when t2.INDEX_MEASURE ='001' and t1.unit<>'%' then t2.index_val-t4.index_val
   else 0 end) as accu_index_value_m --None
    -- 5
    ,sum(case when t2.INDEX_MEASURE in ('015','001') then t2.index_val else 0 end) as accu_index_value_y --None
    ,'001' as measure_no                                         --None
    ,'当期值' as index_measure                                      --None
    ,t2.curr_cd as curr_no                                       --None
    ,decode(t2.curr_cd,'CNY','人民币','BWB','本外币合计') as curr_name   --None
    -- 10
    ,to_date('${batch_date}','yyyymmdd') as etl_dt               --None
    ,TO_TIMESTAMP('${batch_timestamp}','yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp --None
 from mtl_fdl_idx_index_data t2 --None 
INNER JOIN mtl_fml_f99_int_org_info_new t3 --None 
 on t2.org_no = t3.org_id
   
   and t3.etl_dt = to_date('${batch_date}','yyyymmdd')
INNER JOIN mc_index_define t1 --None 
 on t2.index_no=t1.index_no
 and t1.etl_dt=to_date('20250429','yyyymmdd')--固定不改
 and t1.index_clsaa_f_mcs='盈利类'
LEFT JOIN mtl_fdl_idx_index_data t4 --None 
 on t4.index_no=t2.index_no
and t4.org_no=t2.org_no
and t4.curr_cd=t2.curr_cd
and t4.INDEX_MEASURE = '001'
and t4.etl_dt=to_date('${last_month_end}','yyyymmdd')

where t2.etl_dt=to_date('${batch_date}','yyyymmdd')
 and t2.curr_cd in ('CNY','BWB')
 and t2.INDEX_MEASURE in ('013','015','001')
 and t2.org_no=(case when t1.index_no_mcs in ('JX020501125','JX020501184','JX020501185','JX020501186') then '000000' else t2.org_no end) --部分指标全行只取账面数，分行取其他
GROUP BY t1.index_no_mcs
,t1.index_name_mcs
,t2.org_no
,t3.org_abbr
,t2.curr_cd
,decode(t2.curr_cd,'CNY','人民币','BWB','本外币合计');
commit;


/*==============第43组==============*/

--指标结果表03:财务集市绩效指标结果表-盈利类
insert into ${idl_schema}.tmp_mc_index_fact_jxkh_ind_result_3(
    index_no_mcs                                                 --指标编号_管驾
    ,index_name_mcs                                              --指标名称_管驾
    ,org_no                                                      --机构编号
    ,org_name                                                    --机构名称
    ,accu_index_value_m                                          --当月值
    -- 5
    ,accu_index_value_y                                          --当年值
    ,measure_no                                                  --度量编号
    ,index_measure                                               --度量名称
    ,curr_no                                                     --币种代码
    ,curr_name                                                   --币种名称
    -- 10
    ,etl_dt                                                      --ETL处理日期
    ,etl_timestamp                                               --ETL处理时间戳
)
select
    t1.index_no_mcs as index_no_mcs                              --None
    ,t1.index_name_mcs as index_name_mcs                         --None
    ,t2.org_no as org_no                                         --None
    ,t3.org_abbr as org_name                                     --None
    ,sum(case when t2.INDEX_MEASURE ='013' and t1.unit='%' then t2.index_val 
         when t2.INDEX_MEASURE ='001' and t1.unit<>'%' then t2.index_val-t4.index_val
   else 0 end) as accu_index_value_m --None
    -- 5
    ,sum(case when t2.INDEX_MEASURE in ('015','001') then t2.index_val else 0 end) as accu_index_value_y --None
    ,'001' as measure_no                                         --None
    ,'当期值' as index_measure                                      --None
    ,t2.curr_cd as curr_no                                       --None
    ,decode(t2.curr_cd,'CNY','人民币','BWB','本外币合计') as curr_name   --None
    -- 10
    ,to_date('${batch_date}','yyyymmdd') as etl_dt               --None
    ,TO_TIMESTAMP('${batch_timestamp}','yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp --None
 from mtl_fdl_idx_index_data_jx t2 --None 
INNER JOIN mtl_fml_f99_int_org_info_new t3 --None 
 on t2.org_no = t3.org_id
   
   and t3.etl_dt = to_date('${batch_date}','yyyymmdd')
INNER JOIN mc_index_define t1 --None 
 on t2.index_no=t1.index_no
 and t1.etl_dt=to_date('20250429','yyyymmdd')--固定不改
 and t1.index_clsaa_f_mcs='盈利类'
LEFT JOIN mtl_fdl_idx_index_data t4 --None 
 on t4.index_no=t2.index_no
and t4.org_no=t2.org_no
and t4.curr_cd=t2.curr_cd
and t4.INDEX_MEASURE = '001'
and t4.etl_dt=to_date('${last_month_end}','yyyymmdd')

where t2.etl_dt=to_date('${batch_date}','yyyymmdd')
 and t2.curr_cd in ('CNY','BWB')
 and t2.INDEX_MEASURE in ('013','015','001')
 and t2.org_no=(case when t1.index_no_mcs in ('JX020501125','JX020501184','JX020501185','JX020501186') then '000000' else t2.org_no end) --部分指标全行只取账面数，分行取其他
GROUP BY t1.index_no_mcs
,t1.index_name_mcs
,t2.org_no
,t3.org_abbr
,t2.curr_cd
,decode(t2.curr_cd,'CNY','人民币','BWB','本外币合计');
commit;


/*==============第44组==============*/

--指标结果表03:财务集市绩效指标结果表-盈利类
insert into ${idl_schema}.tmp_mc_index_fact_jxkh_ind_result_3(
    index_no_mcs                                                 --指标编号_管驾
    ,index_name_mcs                                              --指标名称_管驾
    ,org_no                                                      --机构编号
    ,org_name                                                    --机构名称
    ,accu_index_value_m                                          --当月值
    -- 5
    ,accu_index_value_y                                          --当年值
    ,measure_no                                                  --度量编号
    ,index_measure                                               --度量名称
    ,curr_no                                                     --币种代码
    ,curr_name                                                   --币种名称
    -- 10
    ,etl_dt                                                      --ETL处理日期
    ,etl_timestamp                                               --ETL处理时间戳
)
select
    'JX0102020401' as index_no_mcs                               --None
    ,'回购及拆入累计利息支出' as index_name_mcs                             --None
    ,t2.org_no as org_no                                         --None
    ,t3.org_abbr as org_name                                     --None
    ,sum(t2.index_val-t4.index_val) as accu_index_value_m        --None
    -- 5
    ,sum(t2.index_val) as accu_index_value_y                     --None
    ,'001' as measure_no                                         --None
    ,'当期值' as index_measure                                      --None
    ,t2.curr_cd as curr_no                                       --None
    ,decode(t2.curr_cd,'CNY','人民币','BWB','本外币合计') as curr_name   --None
    -- 10
    ,to_date('${batch_date}','yyyymmdd') as etl_dt               --None
    ,TO_TIMESTAMP('${batch_timestamp}','yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp --None
 from mtl_fdl_idx_index_data t2 --None 
INNER JOIN mtl_fml_f99_int_org_info_new t3 --None 
 on t2.org_no = t3.org_id  
   and t3.etl_dt = to_date('${batch_date}','yyyymmdd')
LEFT JOIN mtl_fdl_idx_index_data t4 --None 
 on t4.index_no=t2.index_no
and t4.org_no=t2.org_no
and t4.curr_cd=t2.curr_cd
and t4.INDEX_MEASURE = '001'
and t4.etl_dt=to_date('${last_month_end}','yyyymmdd')

where t2.etl_dt=to_date('${batch_date}','yyyymmdd')
 and t2.curr_cd in ('CNY','BWB')
 and t2.INDEX_MEASURE in ('013','015','001')
 and t2.index_no in ('FM0500063','FM0500116')
GROUP BY t2.org_no
,t3.org_abbr
,t2.curr_cd
,decode(t2.curr_cd,'CNY','人民币','BWB','本外币合计');
commit;


/*==============第45组==============*/

--指标结果表03:同业存单明细汇总-资金交易部同业存单累计利息支出
insert into ${idl_schema}.tmp_mc_index_fact_jxkh_ind_result_3(
    index_no_mcs                                                 --指标编号_管驾
    ,index_name_mcs                                              --指标名称_管驾
    ,org_no                                                      --机构编号
    ,org_name                                                    --机构名称
    ,accu_index_value_m                                          --当月值
    -- 5
    ,accu_index_value_y                                          --当年值
    ,measure_no                                                  --度量编号
    ,index_measure                                               --度量名称
    ,curr_no                                                     --币种代码
    ,curr_name                                                   --币种名称
    -- 10
    ,etl_dt                                                      --ETL处理日期
    ,etl_timestamp                                               --ETL处理时间戳
)
select
    'JX0102020391' as index_no_mcs                               --None
    ,'资金交易部同业存单累计利息支出' as index_name_mcs                         --None
    ,'896821' as org_no                                          --None
    ,'' as org_name                                              --None
    ,sum(nvl(t2.ftplxsrylj,0)) as accu_index_value_m             --None
    -- 5
    ,sum(nvl(t2.ftplxsrnlj,0)) as accu_index_value_y             --None
    ,'001' as measure_no                                         --None
    ,'当前值' as index_measure                                      --None
    ,'BWB' as curr_no                                            --None
    ,'本外币合计' as curr_name                                        --None
    -- 10
    ,to_date('${batch_date}','yyyymmdd') as etl_dt               --None
    ,TO_TIMESTAMP('${batch_timestamp}','yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp --None
 from itl_edw_pams_jxbb_tycdmx t2 --None 

where t2.etl_dt=to_date('${batch_date}','yyyymmdd')
and t2.ssjgmc like '%资金交易部%'
and t2.tjrq = '${batch_date}'
and t2.FPJS='1'
 
;
commit;


/*==============第46组==============*/

--指标结果表03:财务集市指标结果表-回购及拆入付息率
insert into ${idl_schema}.tmp_mc_index_fact_jxkh_ind_result_3(
    index_no_mcs                                                 --指标编号_管驾
    ,index_name_mcs                                              --指标名称_管驾
    ,org_no                                                      --机构编号
    ,org_name                                                    --机构名称
    ,accu_index_value_m                                          --当月值
    -- 5
    ,accu_index_value_y                                          --当年值
    ,measure_no                                                  --度量编号
    ,index_measure                                               --度量名称
    ,curr_no                                                     --币种代码
    ,curr_name                                                   --币种名称
    -- 10
    ,etl_dt                                                      --ETL处理日期
    ,etl_timestamp                                               --ETL处理时间戳
)
select
    'JX020302110' as index_no_mcs                                --None
    ,'回购及拆入付息率' as index_name_mcs                                --None
    ,t2.org_no as org_no                                         --None
    ,t3.org_abbr as org_name                                     --None
    ,case when sum(t5.index_value)=0 then 0 else sum(t2.index_val-t4.index_val)/sum(t5.index_value)* max(to_char(add_months(trunc(t2.etl_dt, 'YEAR'), 12) - 1, 'DDD')) / max(extract(day from t2.etl_dt)) end as accu_index_value_m --None
    -- 5
    ,case when sum(t6.index_value)=0 then 0 else sum(t2.index_val)/sum(t6.index_value)* max(to_char(add_months(trunc(t2.etl_dt, 'YEAR'), 12) - 1, 'DDD')) / max(to_char(t2.etl_dt, 'DDD')) end as accu_index_value_y --None
    ,'001' as measure_no                                         --None
    ,'当期值' as index_measure                                      --None
    ,t2.curr_cd as curr_no                                       --None
    ,decode(t2.curr_cd,'CNY','人民币','BWB','本外币合计') as curr_name   --None
    -- 10
    ,to_date('${batch_date}','yyyymmdd') as etl_dt               --None
    ,TO_TIMESTAMP('${batch_timestamp}','yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp --None
 from mtl_fdl_idx_index_data t2 --None 
INNER JOIN mtl_fml_f99_int_org_info_new t3 --None 
 on t2.org_no = t3.org_id
   and t3.etl_dt = to_date('${batch_date}','yyyymmdd')
LEFT JOIN mtl_fdl_idx_index_data t4 --None 
 on t4.index_no=t2.index_no
and t4.org_no=t2.org_no
and t4.curr_cd=t2.curr_cd
and t4.INDEX_MEASURE = '001'
and t4.etl_dt=to_date('${last_month_end}','yyyymmdd')
LEFT JOIN tmp_mc_index_fact_jxkh_ind_result_1 t5 --None 
 on t5.index_no_mcs='JX010202040'
and t5.org_no=t2.org_no
and t5.curr_no=t2.curr_cd
and t5.MEASURE_NO='002'
LEFT JOIN tmp_mc_index_fact_jxkh_ind_result_1 t6 --None 
 on t6.index_no_mcs='JX010202040'
and t6.org_no=t2.org_no
and t6.curr_no=t2.curr_cd
and t6.MEASURE_NO='004'

where t2.etl_dt=to_date('${batch_date}','yyyymmdd')
 and t2.curr_cd in ('CNY','BWB')
 and t2.INDEX_MEASURE ='001'
 and t2.index_no in ('FM0500063','FM0500116')
GROUP BY t2.org_no
,t3.org_abbr
,t2.curr_cd
,decode(t2.curr_cd,'CNY','人民币','BWB','本外币合计');
commit;


/*==============第47组==============*/

--指标结果表03:公司指标汇总表-盈利类-全行
insert into ${idl_schema}.tmp_mc_index_fact_jxkh_ind_result_3(
    index_no_mcs                                                 --指标编号_管驾
    ,index_name_mcs                                              --指标名称_管驾
    ,org_no                                                      --机构编号
    ,org_name                                                    --机构名称
    ,accu_index_value_m                                          --当月值
    -- 5
    ,accu_index_value_y                                          --当年值
    ,measure_no                                                  --度量编号
    ,index_measure                                               --度量名称
    ,curr_no                                                     --币种代码
    ,curr_name                                                   --币种名称
    -- 10
    ,etl_dt                                                      --ETL处理日期
    ,etl_timestamp                                               --ETL处理时间戳
)
select
    t1.index_no_mcs as index_no_mcs                              --None
    ,t1.index_name_mcs as index_name_mcs                         --None
    ,t2.org_or_user_id as org_no                                 --None
    ,t3.org_abbr as org_name                                     --None
    ,sum(case when t2.INDEX_CYCLE='M' then t2.value else 0 end) as accu_index_value_m --None
    -- 5
    ,sum(case when t2.INDEX_CYCLE='Y' then t2.value else 0 end) as accu_index_value_y --None
    ,'001' as measure_no                                         --None
    ,'当期值' as index_measure                                      --None
    ,'BWB' as curr_no                                            --None
    ,'本外币合计' as curr_name                                        --None
    -- 10
    ,to_date('${batch_date}','yyyymmdd') as etl_dt               --None
    ,TO_TIMESTAMP('${batch_timestamp}','yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp --None
 from itl_ccrw_u_ip_result_ccrw_mcss t2 --None 
INNER JOIN mtl_cmm_intnal_org_info t3 --None 
 on t2.org_or_user_id = t3.org_id
   and t3.etl_dt = to_date('${batch_date}','yyyymmdd')
INNER JOIN mc_index_define t1 --None 
 on t1.index_no=t2.bk_index_id
 and t1.etl_dt=to_date('20250429','yyyymmdd')--固定不改
 and t1.index_clsaa_f_mcs='盈利类'

where t2.etl_dt=to_date('${batch_date}','yyyymmdd')
 and t2.FIT_OBJ='ORG'
 and t2.ccy_type='2'
GROUP BY t1.index_no_mcs
,t1.index_name_mcs
,t2.org_or_user_id
,t3.org_abbr
;
commit;


/*==============第48组==============*/

--指标结果表03:同业指标汇总表-盈利类-全行
insert into ${idl_schema}.tmp_mc_index_fact_jxkh_ind_result_3(
    index_no_mcs                                                 --指标编号_管驾
    ,index_name_mcs                                              --指标名称_管驾
    ,org_no                                                      --机构编号
    ,org_name                                                    --机构名称
    ,accu_index_value_m                                          --当月值
    -- 5
    ,accu_index_value_y                                          --当年值
    ,measure_no                                                  --度量编号
    ,index_measure                                               --度量名称
    ,curr_no                                                     --币种代码
    ,curr_name                                                   --币种名称
    -- 10
    ,etl_dt                                                      --ETL处理日期
    ,etl_timestamp                                               --ETL处理时间戳
)
select
    t1.index_no_mcs as index_no_mcs                              --None
    ,t1.index_name_mcs as index_name_mcs                         --None
    ,t3.org_id as org_no                                         --None
    ,t3.org_abbr as org_name                                     --None
    ,sum(case when t2.INDEX_MX_ID in (
'CW40002',
'CW40003',
'CW40008',
'CW40009',
'CW40006',
'CW40007',
'CW00204',
'CW00013',
'CW00274',
'CW00206',
'CW00322',
'CW00001',
'CW00264',
'CW00270',
'CW00272',
'CW00208')then nvl(t2.value,0) else 0 end) as accu_index_value_m --None
    -- 5
    ,sum(case when t2.INDEX_MX_ID in (
'CW00357',
'CW00335',
'CW00345',
'CW00347',
'CW00339',
'CW00341',
'CW00205',
'CW00014',
'CW00275',
'CW00207',
'CW00323',
'CW00002',
'CW00265',
'CW00271',
'CW00273',
'CW00209')then nvl(t2.value,0) else 0 end) as accu_index_value_y --None
    ,'001' as measure_no                                         --None
    ,'当期值' as index_measure                                      --None
    ,'BWB' as curr_no                                            --None
    ,'本外币合计' as curr_name                                        --None
    -- 10
    ,to_date('${batch_date}','yyyymmdd') as etl_dt               --None
    ,TO_TIMESTAMP('${batch_timestamp}','yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp --None
 from itl_ccrw_u_ip_result_icrw_mcss t2 --None 
INNER JOIN mtl_cmm_intnal_org_info t3 --None 
 on (case when t2.org_or_user_id like 'HZJG896811%' then '000000' end) = t3.org_id
   and t3.etl_dt = to_date('${batch_date}','yyyymmdd')
INNER JOIN mc_index_define t1 --None 
 on t1.index_no_mcs=(case 
when t2.index_mx_id in ('CW40002','CW00357') then 'JX020301112'
when t2.index_mx_id in ('CW40003','CW00335') then 'JX020301117'
when t2.index_mx_id in ('CW40008','CW00345') then 'JX020302118'
when t2.index_mx_id in ('CW40009','CW00347') then 'JX020302119'
when t2.index_mx_id in ('CW40006','CW00339') then 'JX020302120'
when t2.index_mx_id in ('CW40007','CW00341') then 'JX020302121'
when t2.index_mx_id in ('CW00204','CW00205') then 'JX020504168'
when t2.index_mx_id in ('CW00013','CW00014') then 'JX020505169'
when t2.index_mx_id in ('CW00274','CW00275') then 'JX020505170'
when t2.index_mx_id in ('CW00206','CW00207') then 'JX020504175'
when t2.index_mx_id in ('CW00322','CW00323') then 'JX020505176'
when t2.index_mx_id in ('CW00001','CW00002') then 'JX020505177'
when t2.index_mx_id in ('CW00264','CW00265') then 'JX020506178'
when t2.index_mx_id in ('CW00270','CW00271') then 'JX020506179'
when t2.index_mx_id in ('CW00272','CW00273') then 'JX020506180'
when t2.index_mx_id in ('CW00208','CW00209') then 'JX020504181'
end)
 and t1.etl_dt=to_date('20250429','yyyymmdd')--固定不改
 and t1.index_clsaa_f_mcs='盈利类'

where t2.etl_dt=to_date('${batch_date}','yyyymmdd')
 and t2.FIT_OBJ='ORG'
 and t2.ccy_type in('2','6')
 AND ((T2.INDEX_CYCLE_VALUE='${batch_date}'and T2.INDEX_CYCLE='D') or T2.INDEX_CYCLE<>'D')
 and t2.INDEX_MX_ID in (
'CW40002','CW00357',
'CW40003','CW00335',
'CW40008','CW00345',
'CW40009','CW00347',
'CW40006','CW00339',
'CW40007','CW00341',
'CW00204','CW00205',
'CW00013','CW00014',
'CW00274','CW00275',
'CW00206','CW00207',
'CW00322','CW00323',
'CW00001','CW00002',
'CW00264','CW00265',
'CW00270','CW00271',
'CW00272','CW00273',
'CW00208','CW00209'
)
and t2.org_or_user_id like 'HZJG896811%'
GROUP BY t1.index_no_mcs
,t1.index_name_mcs
,t3.org_id
,t3.org_abbr
;
commit;


/*==============第49组==============*/

--指标结果表03:同业指标汇总表-盈利类-分行
insert into ${idl_schema}.tmp_mc_index_fact_jxkh_ind_result_3(
    index_no_mcs                                                 --指标编号_管驾
    ,index_name_mcs                                              --指标名称_管驾
    ,org_no                                                      --机构编号
    ,org_name                                                    --机构名称
    ,accu_index_value_m                                          --当月值
    -- 5
    ,accu_index_value_y                                          --当年值
    ,measure_no                                                  --度量编号
    ,index_measure                                               --度量名称
    ,curr_no                                                     --币种代码
    ,curr_name                                                   --币种名称
    -- 10
    ,etl_dt                                                      --ETL处理日期
    ,etl_timestamp                                               --ETL处理时间戳
)
select
    t1.index_no_mcs as index_no_mcs                              --None
    ,t1.index_name_mcs as index_name_mcs                         --None
    ,t3.org_id as org_no                                         --None
    ,t3.org_abbr as org_name                                     --None
    ,sum(case when t2.INDEX_MX_ID in (
'CW40004',
'CW40005',
'CW40012',
'CW40013',
'CW40010',
'CW40011',
'CW01720',
'CW01125',
'CW01298',
'CW01346',
'CW01358',
'CW01370',
'CW01348',
'CW01354',
'CW01356',
'CW01382')then nvl(t2.value,0) else 0 end) as accu_index_value_m --None
    -- 5
    ,sum(case when t2.INDEX_MX_ID in (
'CW01397',
'CW01722',
'CW01451',
'CW01453',
'CW01455',
'CW01457',
'CW01721',
'CW01126',
'CW01299',
'CW01347',
'CW01359',
'CW01371',
'CW01349',
'CW01355',
'CW01357',
'CW01383')then nvl(t2.value,0) else 0 end) as accu_index_value_y --None
    ,'001' as measure_no                                         --None
    ,'当期值' as index_measure                                      --None
    ,'BWB' as curr_no                                            --None
    ,'本外币合计' as curr_name                                        --None
    -- 10
    ,to_date('${batch_date}','yyyymmdd') as etl_dt               --None
    ,TO_TIMESTAMP('${batch_timestamp}','yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp --None
 from itl_ccrw_u_ip_result_icrw_mcss t2 --None 
INNER JOIN mtl_cmm_intnal_org_info t3 --None 
 on t2.org_or_user_id = t3.org_id
   and t3.etl_dt = to_date('${batch_date}','yyyymmdd')
INNER JOIN mc_index_define t1 --None 
 on t1.index_no_mcs=(case 
when t2.index_mx_id in ('CW40004','CW01397') then 'JX020301112' 
 when t2.index_mx_id in ('CW40005','CW01722') then 'JX020301117' 
 when t2.index_mx_id in ('CW40012','CW01451') then 'JX020302118' 
 when t2.index_mx_id in ('CW40013','CW01453') then 'JX020302119' 
 when t2.index_mx_id in ('CW40010','CW01455') then 'JX020302120' 
 when t2.index_mx_id in ('CW40011','CW01457') then 'JX020302121' 
 when t2.index_mx_id in ('CW01720','CW01721') then 'JX020504168' 
 when t2.index_mx_id in ('CW01125','CW01126') then 'JX020505169' 
 when t2.index_mx_id in ('CW01298','CW01299') then 'JX020505170' 
 when t2.index_mx_id in ('CW01346','CW01347') then 'JX020504175' 
 when t2.index_mx_id in ('CW01358','CW01359') then 'JX020505176' 
 when t2.index_mx_id in ('CW01370','CW01371') then 'JX020505177' 
 when t2.index_mx_id in ('CW01348','CW01349') then 'JX020506178' 
 when t2.index_mx_id in ('CW01354','CW01355') then 'JX020506179' 
 when t2.index_mx_id in ('CW01356','CW01357') then 'JX020506180' 
 when t2.index_mx_id in ('CW01382','CW01383') then 'JX020504181'
end)
 and t1.etl_dt=to_date('20250429','yyyymmdd')--固定不改
 and t1.index_clsaa_f_mcs='盈利类'

where t2.etl_dt=to_date('${batch_date}','yyyymmdd')
 and t2.FIT_OBJ='ORG'
 and t2.ccy_type in('2','6')
 AND ((T2.INDEX_CYCLE_VALUE='${batch_date}'and T2.INDEX_CYCLE='D') or T2.INDEX_CYCLE<>'D')
 and t2.INDEX_MX_ID in (
'CW40004','CW01397',
'CW40005','CW01722',
'CW40012','CW01451',
'CW40013','CW01453',
'CW40010','CW01455',
'CW40011','CW01457',
'CW01720','CW01721',
'CW01125','CW01126',
'CW01298','CW01299',
'CW01346','CW01347',
'CW01358','CW01359',
'CW01370','CW01371',
'CW01348','CW01349',
'CW01354','CW01355',
'CW01356','CW01357',
'CW01382','CW01383'
)
and t2.org_or_user_id <> '000000'
GROUP BY t1.index_no_mcs
,t1.index_name_mcs
,t3.org_id
,t3.org_abbr
;
commit;


/*==============第50组==============*/

--指标结果表03:同业指标汇总表-盈利类-特殊处理1-全行
insert into ${idl_schema}.tmp_mc_index_fact_jxkh_ind_result_3(
    index_no_mcs                                                 --指标编号_管驾
    ,index_name_mcs                                              --指标名称_管驾
    ,org_no                                                      --机构编号
    ,org_name                                                    --机构名称
    ,accu_index_value_m                                          --当月值
    -- 5
    ,accu_index_value_y                                          --当年值
    ,measure_no                                                  --度量编号
    ,index_measure                                               --度量名称
    ,curr_no                                                     --币种代码
    ,curr_name                                                   --币种名称
    -- 10
    ,etl_dt                                                      --ETL处理日期
    ,etl_timestamp                                               --ETL处理时间戳
)
select
    t1.index_no_mcs as index_no_mcs                              --None
    ,t1.index_name_mcs as index_name_mcs                         --None
    ,t3.org_id as org_no                                         --None
    ,t3.org_abbr as org_name                                     --None
    ,sum(case when t2.INDEX_MX_ID in (
'CW10037',
'CW00236')then nvl(t2.value,0) else 0 end) as accu_index_value_m --None
    -- 5
    ,sum(case when t2.INDEX_MX_ID in (
'CW10038',
'CW00237')then nvl(t2.value,0) else 0 end) as accu_index_value_y --None
    ,'001' as measure_no                                         --None
    ,'当期值' as index_measure                                      --None
    ,'BWB' as curr_no                                            --None
    ,'本外币合计' as curr_name                                        --None
    -- 10
    ,to_date('${batch_date}','yyyymmdd') as etl_dt               --None
    ,TO_TIMESTAMP('${batch_timestamp}','yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp --None
 from itl_ccrw_u_ip_result_icrw_mcss t2 --None 
INNER JOIN mtl_cmm_intnal_org_info t3 --None 
 on (case when t2.org_or_user_id like 'HZJG896811%' then '000000' end) = t3.org_id
   and t3.etl_dt = to_date('${batch_date}','yyyymmdd')
INNER JOIN mc_index_define t1 --None 
 on t1.index_no_mcs=(case 
when t2.index_mx_id in ('CW10038','CW00236','CW10037','CW00237') then 'JX020506172'
end)
 and t1.etl_dt=to_date('20250429','yyyymmdd')--固定不改
 and t1.index_clsaa_f_mcs='盈利类'

where t2.etl_dt=to_date('${batch_date}','yyyymmdd')
 and t2.FIT_OBJ='ORG'
 and t2.ccy_type in('2','6')
 AND ((T2.INDEX_CYCLE_VALUE='${batch_date}'and T2.INDEX_CYCLE='D') or T2.INDEX_CYCLE<>'D')
 and t2.INDEX_MX_ID in (
'CW10038','CW00236',
'CW10037','CW00237'
)
and t2.org_or_user_id like 'HZJG896811%'
GROUP BY t1.index_no_mcs
,t1.index_name_mcs
,t3.org_id
,t3.org_abbr
;
commit;


/*==============第51组==============*/

--指标结果表03:同业指标汇总表-盈利类-特殊处理1-分行
insert into ${idl_schema}.tmp_mc_index_fact_jxkh_ind_result_3(
    index_no_mcs                                                 --指标编号_管驾
    ,index_name_mcs                                              --指标名称_管驾
    ,org_no                                                      --机构编号
    ,org_name                                                    --机构名称
    ,accu_index_value_m                                          --当月值
    -- 5
    ,accu_index_value_y                                          --当年值
    ,measure_no                                                  --度量编号
    ,index_measure                                               --度量名称
    ,curr_no                                                     --币种代码
    ,curr_name                                                   --币种名称
    -- 10
    ,etl_dt                                                      --ETL处理日期
    ,etl_timestamp                                               --ETL处理时间戳
)
select
    t1.index_no_mcs as index_no_mcs                              --None
    ,t1.index_name_mcs as index_name_mcs                         --None
    ,t3.org_id as org_no                                         --None
    ,t3.org_abbr as org_name                                     --None
    ,sum(case when t2.INDEX_MX_ID in (
'CW10039',
'CW01093')then nvl(t2.value,0) else 0 end) as accu_index_value_m --None
    -- 5
    ,sum(case when t2.INDEX_MX_ID in (
'CW10040',
'CW01094')then nvl(t2.value,0) else 0 end) as accu_index_value_y --None
    ,'001' as measure_no                                         --None
    ,'当期值' as index_measure                                      --None
    ,'BWB' as curr_no                                            --None
    ,'本外币合计' as curr_name                                        --None
    -- 10
    ,to_date('${batch_date}','yyyymmdd') as etl_dt               --None
    ,TO_TIMESTAMP('${batch_timestamp}','yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp --None
 from itl_ccrw_u_ip_result_icrw_mcss t2 --None 
INNER JOIN mtl_cmm_intnal_org_info t3 --None 
 on t2.org_or_user_id = t3.org_id
   and t3.etl_dt = to_date('${batch_date}','yyyymmdd')
INNER JOIN mc_index_define t1 --None 
 on t1.index_no_mcs=(case 
when t2.index_mx_id in ('CW10039','CW01093','CW10040','CW01094') then 'JX020506172' 
end)
 and t1.etl_dt=to_date('20250429','yyyymmdd')--固定不改
 and t1.index_clsaa_f_mcs='盈利类'

where t2.etl_dt=to_date('${batch_date}','yyyymmdd')
 and t2.FIT_OBJ='ORG'
 and t2.ccy_type in('2','6')
 AND ((T2.INDEX_CYCLE_VALUE='${batch_date}'and T2.INDEX_CYCLE='D') or T2.INDEX_CYCLE<>'D')
 and t2.INDEX_MX_ID in (
'CW10039','CW01093',
'CW10040','CW01094'
)
and t2.org_or_user_id <> '000000'
GROUP BY t1.index_no_mcs
,t1.index_name_mcs
,t3.org_id
,t3.org_abbr
;
commit;


/*==============第52组==============*/

--指标结果表03:同业指标汇总表-盈利类-特殊处理2-全行
insert into ${idl_schema}.tmp_mc_index_fact_jxkh_ind_result_3(
    index_no_mcs                                                 --指标编号_管驾
    ,index_name_mcs                                              --指标名称_管驾
    ,org_no                                                      --机构编号
    ,org_name                                                    --机构名称
    ,accu_index_value_m                                          --当月值
    -- 5
    ,accu_index_value_y                                          --当年值
    ,measure_no                                                  --度量编号
    ,index_measure                                               --度量名称
    ,curr_no                                                     --币种代码
    ,curr_name                                                   --币种名称
    -- 10
    ,etl_dt                                                      --ETL处理日期
    ,etl_timestamp                                               --ETL处理时间戳
)
select
    t1.index_no_mcs as index_no_mcs                              --None
    ,t1.index_name_mcs as index_name_mcs                         --None
    ,t3.org_id as org_no                                         --None
    ,t3.org_abbr as org_name                                     --None
    ,sum(case when t2.INDEX_MX_ID in ('CW00200','CW00204') then 0-nvl(t2.value,0) else nvl(t2.value,0) end) as accu_index_value_m --None
    -- 5
    ,sum(case when t2.INDEX_MX_ID in('CW00201','CW00205') then 0-nvl(t2.value,0) else nvl(t2.value,0) end) as accu_index_value_y --None
    ,'001' as measure_no                                         --None
    ,'当期值' as index_measure                                      --None
    ,'BWB' as curr_no                                            --None
    ,'本外币合计' as curr_name                                        --None
    -- 10
    ,to_date('${batch_date}','yyyymmdd') as etl_dt               --None
    ,TO_TIMESTAMP('${batch_timestamp}','yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp --None
 from itl_ccrw_u_ip_result_icrw_mcss t2 --None 
INNER JOIN mtl_cmm_intnal_org_info t3 --None 
 on (case when t2.org_or_user_id like 'HZJG896811%' then '000000' end) = t3.org_id
   and t3.etl_dt = to_date('${batch_date}','yyyymmdd')
INNER JOIN mc_index_define t1 --None 
 on t1.index_no_mcs=(case 
when t2.index_mx_id in ('CW01015','CW00200','CW00204','CW01003','CW00201','CW00205') then 'JX020506174'
end)
 and t1.etl_dt=to_date('20250429','yyyymmdd')--固定不改
 and t1.index_clsaa_f_mcs='盈利类'

where t2.etl_dt=to_date('${batch_date}','yyyymmdd')
 and t2.FIT_OBJ='ORG'
 and t2.ccy_type in('2','6')
 AND ((T2.INDEX_CYCLE_VALUE='${batch_date}'and T2.INDEX_CYCLE='D') or T2.INDEX_CYCLE<>'D')
 and t2.INDEX_MX_ID in (
'CW01015','CW00200','CW00204',
'CW01003','CW00201','CW00205'
)
and t2.org_or_user_id like 'HZJG896811%'
GROUP BY t1.index_no_mcs
,t1.index_name_mcs
,t3.org_id
,t3.org_abbr
;
commit;


/*==============第53组==============*/

--指标结果表03:同业指标汇总表-盈利类-特殊处理2-分行
insert into ${idl_schema}.tmp_mc_index_fact_jxkh_ind_result_3(
    index_no_mcs                                                 --指标编号_管驾
    ,index_name_mcs                                              --指标名称_管驾
    ,org_no                                                      --机构编号
    ,org_name                                                    --机构名称
    ,accu_index_value_m                                          --当月值
    -- 5
    ,accu_index_value_y                                          --当年值
    ,measure_no                                                  --度量编号
    ,index_measure                                               --度量名称
    ,curr_no                                                     --币种代码
    ,curr_name                                                   --币种名称
    -- 10
    ,etl_dt                                                      --ETL处理日期
    ,etl_timestamp                                               --ETL处理时间戳
)
select
    t1.index_no_mcs as index_no_mcs                              --None
    ,t1.index_name_mcs as index_name_mcs                         --None
    ,t3.org_id as org_no                                         --None
    ,t3.org_abbr as org_name                                     --None
    ,sum(case when t2.INDEX_MX_ID ='CW01093' then 0-nvl(t2.value,0) else nvl(t2.value,0) end) as accu_index_value_m --None
    -- 5
    ,sum(case when t2.INDEX_MX_ID ='CW01094' then 0-nvl(t2.value,0) else nvl(t2.value,0) end) as accu_index_value_y --None
    ,'001' as measure_no                                         --None
    ,'当期值' as index_measure                                      --None
    ,'BWB' as curr_no                                            --None
    ,'本外币合计' as curr_name                                        --None
    -- 10
    ,to_date('${batch_date}','yyyymmdd') as etl_dt               --None
    ,TO_TIMESTAMP('${batch_timestamp}','yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp --None
 from itl_ccrw_u_ip_result_icrw_mcss t2 --None 
INNER JOIN mtl_cmm_intnal_org_info t3 --None 
 on t2.org_or_user_id = t3.org_id
   and t3.etl_dt = to_date('${batch_date}','yyyymmdd')
INNER JOIN mc_index_define t1 --None 
 on t1.index_no_mcs=(case 
when t2.index_mx_id in ('CW10015','CW01093','CW10016','CW01094') then 'JX020506174' 
end)
 and t1.etl_dt=to_date('20250429','yyyymmdd')--固定不改
 and t1.index_clsaa_f_mcs='盈利类'

where t2.etl_dt=to_date('${batch_date}','yyyymmdd')
 and t2.FIT_OBJ='ORG'
 and t2.ccy_type in('2','6')
 AND ((T2.INDEX_CYCLE_VALUE='${batch_date}'and T2.INDEX_CYCLE='D') or T2.INDEX_CYCLE<>'D')
 and t2.INDEX_MX_ID in (
'CW10015','CW01093',
'CW10016','CW01094'
)
and t2.org_or_user_id <> '000000'
GROUP BY t1.index_no_mcs
,t1.index_name_mcs
,t3.org_id
,t3.org_abbr
;
commit;


/*==============第54组==============*/

--指标结果表03:同业指标汇总表-盈利类-特殊处理2-全行
insert into ${idl_schema}.tmp_mc_index_fact_jxkh_ind_result_3(
    index_no_mcs                                                 --指标编号_管驾
    ,index_name_mcs                                              --指标名称_管驾
    ,org_no                                                      --机构编号
    ,org_name                                                    --机构名称
    ,accu_index_value_m                                          --当月值
    -- 5
    ,accu_index_value_y                                          --当年值
    ,measure_no                                                  --度量编号
    ,index_measure                                               --度量名称
    ,curr_no                                                     --币种代码
    ,curr_name                                                   --币种名称
    -- 10
    ,etl_dt                                                      --ETL处理日期
    ,etl_timestamp                                               --ETL处理时间戳
)
select
    t1.index_no_mcs as index_no_mcs                              --None
    ,t1.index_name_mcs as index_name_mcs                         --None
    ,t3.org_id as org_no                                         --None
    ,t3.org_abbr as org_name                                     --None
    ,sum(case when t2.INDEX_MX_ID in ('CW00204','CW40175') then 0-nvl(t2.value,0) else nvl(t2.value,0) end) as accu_index_value_m --None
    -- 5
    ,sum(case when t2.INDEX_MX_ID in('CW00205','CW40177') then 0-nvl(t2.value,0) else nvl(t2.value,0) end) as accu_index_value_y --None
    ,'001' as measure_no                                         --None
    ,'当期值' as index_measure                                      --None
    ,'BWB' as curr_no                                            --None
    ,'本外币合计' as curr_name                                        --None
    -- 10
    ,to_date('${batch_date}','yyyymmdd') as etl_dt               --None
    ,TO_TIMESTAMP('${batch_timestamp}','yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp --None
 from itl_ccrw_u_ip_result_icrw_mcss t2 --None 
INNER JOIN mtl_cmm_intnal_org_info t3 --None 
 on (case when t2.org_or_user_id like 'HZJG896811%' then '000000' end) = t3.org_id
   and t3.etl_dt = to_date('${batch_date}','yyyymmdd')
INNER JOIN mc_index_define t1 --None 
 on t1.index_no_mcs=(case 
when t2.index_mx_id in ('CW00200','CW00204','CW40175','CW00201','CW00205','CW40177') then 'JX020506171'
end)
 and t1.etl_dt=to_date('20250429','yyyymmdd')--固定不改
 and t1.index_clsaa_f_mcs='盈利类'

where t2.etl_dt=to_date('${batch_date}','yyyymmdd')
 and t2.FIT_OBJ='ORG'
 and t2.ccy_type in('2','6')
 AND ((T2.INDEX_CYCLE_VALUE='${batch_date}'and T2.INDEX_CYCLE='D') or T2.INDEX_CYCLE<>'D')
 and t2.INDEX_MX_ID in (
'CW00200','CW00204','CW40175',
'CW00201','CW00205','CW40177'
)
and t2.org_or_user_id like 'HZJG896811%'
GROUP BY t1.index_no_mcs
,t1.index_name_mcs
,t3.org_id
,t3.org_abbr
;
commit;


/*==============第55组==============*/

--指标结果表03:绩效报表产品筛选汇总-贷款-盈利类-支行
insert into ${idl_schema}.tmp_mc_index_fact_jxkh_ind_result_3(
    index_no_mcs                                                 --指标编号_管驾
    ,index_name_mcs                                              --指标名称_管驾
    ,org_no                                                      --机构编号
    ,org_name                                                    --机构名称
    ,accu_index_value_m                                          --当月值
    -- 5
    ,accu_index_value_y                                          --当年值
    ,measure_no                                                  --度量编号
    ,index_measure                                               --度量名称
    ,curr_no                                                     --币种代码
    ,curr_name                                                   --币种名称
    -- 10
    ,etl_dt                                                      --ETL处理日期
    ,etl_timestamp                                               --ETL处理时间戳
)
select
    t1.index_no_mcs as index_no_mcs                              --None
    ,t1.index_name_mcs as index_name_mcs                         --None
    ,t2.ssjgh as org_no                                          --None
    ,t3.org_abbr as org_name                                     --None
    ,case when t1.index_clsaa_s_mcs='存贷利差情况' then
(case
         when sum(nvl(t2.yrj,0)) = 0 then
          0
         else
          sum(t2.ylx) / sum(t2.yrj) *  max(to_char(add_months(trunc(t2.etl_dt, 'YEAR'), 12) - 1, 'DDD')) / max(extract(day from t2.etl_dt))
       end)
     when  t1.index_clsaa_s_mcs='盈利情况' then sum(nvl(t2.dyftpjsy,0)) end as accu_index_value_m --None
    -- 5
    ,case when t1.index_clsaa_s_mcs='存贷利差情况' then
(case
         when sum(nvl(t2.nrj,0)) = 0 then
          0
         else
          sum(t2.nlx) / sum(t2.nrj) * max(to_char(add_months(trunc(t2.etl_dt, 'YEAR'), 12) - 1, 'DDD')) / max(to_char(t2.etl_dt, 'DDD'))
       end)
     when  t1.index_clsaa_s_mcs='盈利情况' then sum(nvl(t2.ljftpjsy,0)) end as accu_index_value_y --None
    ,'001' as measure_no                                         --None
    ,'当期值' as index_measure                                      --None
    ,decode(t2.bz,'01','CNY','0A','BWB','FF','BWB') as curr_no   --None
    ,decode(t2.bz,'01','人民币','0A','本外币合计','FF','本外币合计') as curr_name --None
    -- 10
    ,to_date('${batch_date}','yyyymmdd') as etl_dt               --None
    ,TO_TIMESTAMP('${batch_timestamp}','yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp --None
 from itl_edw_pams_jxbb_dkftphz t2 --None 
INNER JOIN mtl_cmm_intnal_org_info t3 --None 
 on t2.ssjgh = t3.org_id
   and t3.etl_dt = to_date('${batch_date}','yyyymmdd')
INNER JOIN mc_index_define t1 --None 
 on t1.index_no like 'itl_edw_pams_jxbb_dkftphz%'
 and regexp_like(','||replace(t1.index_no,'itl_edw_pams_jxbb_dkftphz:','')||',',','||t2.cpbh||',')
 and t1.etl_dt=to_date('20250429','yyyymmdd')--固定不改
 and t1.index_clsaa_f_mcs='盈利类'

where t2.etl_dt=to_date('${batch_date}','yyyymmdd')
 and t2.bz in ('01','0A')
 and length(t2.ssjgh)>3
 and t2.ssjgh<>'000000'
GROUP BY t1.index_no_mcs
,t1.index_name_mcs
,t2.ssjgh
,t3.org_abbr
,decode(t2.bz,'01','CNY','0A','BWB','FF','BWB')
,decode(t2.bz,'01','人民币','0A','本外币合计','FF','本外币合计')
,t1.index_clsaa_s_mcs
;
commit;


/*==============第56组==============*/

--指标结果表03:绩效报表产品筛选汇总-贷款-盈利类-分行
insert into ${idl_schema}.tmp_mc_index_fact_jxkh_ind_result_3(
    index_no_mcs                                                 --指标编号_管驾
    ,index_name_mcs                                              --指标名称_管驾
    ,org_no                                                      --机构编号
    ,org_name                                                    --机构名称
    ,accu_index_value_m                                          --当月值
    -- 5
    ,accu_index_value_y                                          --当年值
    ,measure_no                                                  --度量编号
    ,index_measure                                               --度量名称
    ,curr_no                                                     --币种代码
    ,curr_name                                                   --币种名称
    -- 10
    ,etl_dt                                                      --ETL处理日期
    ,etl_timestamp                                               --ETL处理时间戳
)
select
    t1.index_no_mcs as index_no_mcs                              --None
    ,t1.index_name_mcs as index_name_mcs                         --None
    ,substr(t2.ssjgh,1,3) as org_no                              --None
    ,t3.org_abbr as org_name                                     --None
    ,case when t1.index_clsaa_s_mcs='存贷利差情况' then
(case
         when sum(nvl(t2.yrj,0)) = 0 then
          0
         else
          sum(t2.ylx) / sum(t2.yrj) *  max(to_char(add_months(trunc(t2.etl_dt, 'YEAR'), 12) - 1, 'DDD')) / max(extract(day from t2.etl_dt))
       end)
     when  t1.index_clsaa_s_mcs='盈利情况' then sum(nvl(t2.dyftpjsy,0)) end as accu_index_value_m --None
    -- 5
    ,case when t1.index_clsaa_s_mcs='存贷利差情况' then
(case
         when sum(nvl(t2.nrj,0)) = 0 then
          0
         else
          sum(t2.nlx) / sum(t2.nrj) * max(to_char(add_months(trunc(t2.etl_dt, 'YEAR'), 12) - 1, 'DDD')) / max(to_char(t2.etl_dt, 'DDD'))
       end)
     when  t1.index_clsaa_s_mcs='盈利情况' then sum(nvl(t2.ljftpjsy,0)) end as accu_index_value_y --None
    ,'001' as measure_no                                         --None
    ,'当期值' as index_measure                                      --None
    ,decode(t2.bz,'01','CNY','0A','BWB','FF','BWB') as curr_no   --None
    ,decode(t2.bz,'01','人民币','0A','本外币合计','FF','本外币合计') as curr_name --None
    -- 10
    ,to_date('${batch_date}','yyyymmdd') as etl_dt               --None
    ,TO_TIMESTAMP('${batch_timestamp}','yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp --None
 from itl_edw_pams_jxbb_dkftphz t2 --None 
INNER JOIN mtl_cmm_intnal_org_info t3 --None 
 on substr(t2.ssjgh,1,3) = t3.org_id
   and t3.etl_dt = to_date('${batch_date}','yyyymmdd')
INNER JOIN mc_index_define t1 --None 
 on t1.index_no like 'itl_edw_pams_jxbb_dkftphz%'
 and regexp_like(','||replace(t1.index_no,'itl_edw_pams_jxbb_dkftphz:','')||',',','||t2.cpbh||',')
 and t1.etl_dt=to_date('20250429','yyyymmdd')--固定不改
 and t1.index_clsaa_f_mcs='盈利类'

where t2.etl_dt=to_date('${batch_date}','yyyymmdd')
 and t2.bz in ('01','0A')
GROUP BY t1.index_no_mcs
,t1.index_name_mcs
,substr(t2.ssjgh,1,3)
,t3.org_abbr
,decode(t2.bz,'01','CNY','0A','BWB','FF','BWB')
,decode(t2.bz,'01','人民币','0A','本外币合计','FF','本外币合计')
,t1.index_clsaa_s_mcs
;
commit;


/*==============第57组==============*/

--指标结果表03:绩效报表产品筛选汇总-贷款-盈利类-全行
insert into ${idl_schema}.tmp_mc_index_fact_jxkh_ind_result_3(
    index_no_mcs                                                 --指标编号_管驾
    ,index_name_mcs                                              --指标名称_管驾
    ,org_no                                                      --机构编号
    ,org_name                                                    --机构名称
    ,accu_index_value_m                                          --当月值
    -- 5
    ,accu_index_value_y                                          --当年值
    ,measure_no                                                  --度量编号
    ,index_measure                                               --度量名称
    ,curr_no                                                     --币种代码
    ,curr_name                                                   --币种名称
    -- 10
    ,etl_dt                                                      --ETL处理日期
    ,etl_timestamp                                               --ETL处理时间戳
)
select
    t1.index_no_mcs as index_no_mcs                              --None
    ,t1.index_name_mcs as index_name_mcs                         --None
    ,'000000' as org_no                                          --None
    ,'广东华兴银行 ' as org_name                                       --None
    ,case when t1.index_clsaa_s_mcs='存贷利差情况' then
(case
         when sum(nvl(t2.yrj,0)) = 0 then
          0
         else
          sum(t2.ylx) / sum(t2.yrj) *  max(to_char(add_months(trunc(t2.etl_dt, 'YEAR'), 12) - 1, 'DDD')) / max(extract(day from t2.etl_dt))
       end)
     when  t1.index_clsaa_s_mcs='盈利情况' then sum(nvl(t2.dyftpjsy,0)) end as accu_index_value_m --None
    -- 5
    ,case when t1.index_clsaa_s_mcs='存贷利差情况' then
(case
         when sum(nvl(t2.nrj,0)) = 0 then
          0
         else
          sum(t2.nlx) / sum(t2.nrj) * max(to_char(add_months(trunc(t2.etl_dt, 'YEAR'), 12) - 1, 'DDD')) / max(to_char(t2.etl_dt, 'DDD'))
       end)
     when  t1.index_clsaa_s_mcs='盈利情况' then sum(nvl(t2.ljftpjsy,0)) end as accu_index_value_y --None
    ,'001' as measure_no                                         --None
    ,'当期值' as index_measure                                      --None
    ,decode(t2.bz,'01','CNY','0A','BWB','FF','BWB') as curr_no   --None
    ,decode(t2.bz,'01','人民币','0A','本外币合计','FF','本外币合计') as curr_name --None
    -- 10
    ,to_date('${batch_date}','yyyymmdd') as etl_dt               --None
    ,TO_TIMESTAMP('${batch_timestamp}','yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp --None
 from itl_edw_pams_jxbb_dkftphz t2 --None 
INNER JOIN mc_index_define t1 --None 
 on t1.index_no like 'itl_edw_pams_jxbb_dkftphz%'
 and regexp_like(','||replace(t1.index_no,'itl_edw_pams_jxbb_dkftphz:','')||',',','||t2.cpbh||',')
 and t1.etl_dt=to_date('20250429','yyyymmdd')--固定不改
 and t1.index_clsaa_f_mcs='盈利类'

where t2.etl_dt=to_date('${batch_date}','yyyymmdd')
 and t2.bz in ('01','0A')
GROUP BY t1.index_no_mcs
,t1.index_name_mcs
,decode(t2.bz,'01','CNY','0A','BWB','FF','BWB')
,decode(t2.bz,'01','人民币','0A','本外币合计','FF','本外币合计')
,t1.index_clsaa_s_mcs
;
commit;


/*==============第58组==============*/

--指标结果表03:绩效报表产品筛选汇总-存款-盈利类-支行
insert into ${idl_schema}.tmp_mc_index_fact_jxkh_ind_result_3(
    index_no_mcs                                                 --指标编号_管驾
    ,index_name_mcs                                              --指标名称_管驾
    ,org_no                                                      --机构编号
    ,org_name                                                    --机构名称
    ,accu_index_value_m                                          --当月值
    -- 5
    ,accu_index_value_y                                          --当年值
    ,measure_no                                                  --度量编号
    ,index_measure                                               --度量名称
    ,curr_no                                                     --币种代码
    ,curr_name                                                   --币种名称
    -- 10
    ,etl_dt                                                      --ETL处理日期
    ,etl_timestamp                                               --ETL处理时间戳
)
select
    t1.index_no_mcs as index_no_mcs                              --None
    ,t1.index_name_mcs as index_name_mcs                         --None
    ,t2.ssjgh as org_no                                          --None
    ,t3.org_abbr as org_name                                     --None
    ,case when t1.index_clsaa_s_mcs='存贷利差情况' then
(case
         when sum(nvl(t2.zhyrjye,0)) = 0 then
          0
         else
          sum(t2.ftplxzcylj) / sum(t2.zhyrjye) * max(to_char(add_months(trunc(t2.etl_dt, 'YEAR'), 12) - 1, 'DDD')) / max(extract(day from t2.etl_dt))
       end)
when  t1.index_clsaa_s_mcs='盈利情况' then sum(nvl(t2.FTPSYYLJ,0)) end as accu_index_value_m --None
    -- 5
    ,case when t1.index_clsaa_s_mcs='存贷利差情况' then
(case
         when sum(nvl(t2.zhnrjye,0)) = 0 then
          0
         else
          sum(t2.ftplxzcnlj) / sum(t2.zhnrjye) * max(to_char(add_months(trunc(t2.etl_dt, 'YEAR'), 12) - 1, 'DDD')) / max(to_char(t2.etl_dt, 'DDD'))
       end)
when  t1.index_clsaa_s_mcs='盈利情况' then sum(nvl(t2.FTPSYNLJ,0)) end as accu_index_value_y --None
    ,'001' as measure_no                                         --None
    ,'当期值' as index_measure                                      --None
    ,decode(t2.bz,'01','CNY','0A','BWB','FF','BWB') as curr_no   --None
    ,decode(t2.bz,'01','人民币','0A','本外币合计','FF','本外币合计') as curr_name --None
    -- 10
    ,to_date('${batch_date}','yyyymmdd') as etl_dt               --None
    ,TO_TIMESTAMP('${batch_timestamp}','yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp --None
 from itl_edw_pams_jxbb_ckftphz t2 --None 
INNER JOIN mtl_cmm_intnal_org_info t3 --None 
 on t2.ssjgh = t3.org_id
   and t3.etl_dt = to_date('${batch_date}','yyyymmdd')
INNER JOIN mc_index_define t1 --None 
 on t1.index_no like 'itl_edw_pams_jxbb_ckftphz%'
 and regexp_like(','||replace(t1.index_no,'itl_edw_pams_jxbb_ckftphz:','')||',',','||t2.cpmc||',')
 and t1.etl_dt=to_date('20250429','yyyymmdd')--固定不改
 and t1.index_clsaa_f_mcs='盈利类'

where t2.etl_dt=to_date('${batch_date}','yyyymmdd')
 and t2.bz in ('01','0A')
 and length(t2.ssjgh)>3
 and t2.ssjgh<>'000000'
GROUP BY t1.index_no_mcs
,t1.index_name_mcs
,t2.ssjgh
,t3.org_abbr
,decode(t2.bz,'01','CNY','0A','BWB','FF','BWB')
,decode(t2.bz,'01','人民币','0A','本外币合计','FF','本外币合计')
,t1.index_clsaa_s_mcs
;
commit;


/*==============第59组==============*/

--指标结果表03:绩效报表产品筛选汇总-存款-盈利类-分行
insert into ${idl_schema}.tmp_mc_index_fact_jxkh_ind_result_3(
    index_no_mcs                                                 --指标编号_管驾
    ,index_name_mcs                                              --指标名称_管驾
    ,org_no                                                      --机构编号
    ,org_name                                                    --机构名称
    ,accu_index_value_m                                          --当月值
    -- 5
    ,accu_index_value_y                                          --当年值
    ,measure_no                                                  --度量编号
    ,index_measure                                               --度量名称
    ,curr_no                                                     --币种代码
    ,curr_name                                                   --币种名称
    -- 10
    ,etl_dt                                                      --ETL处理日期
    ,etl_timestamp                                               --ETL处理时间戳
)
select
    t1.index_no_mcs as index_no_mcs                              --None
    ,t1.index_name_mcs as index_name_mcs                         --None
    ,substr(t2.ssjgh,1,3) as org_no                              --None
    ,t3.org_abbr as org_name                                     --None
    ,case when t1.index_clsaa_s_mcs='存贷利差情况' then
(case
         when sum(nvl(t2.zhyrjye,0)) = 0 then
          0
         else
          sum(t2.ftplxzcylj) / sum(t2.zhyrjye) * max(to_char(add_months(trunc(t2.etl_dt, 'YEAR'), 12) - 1, 'DDD')) / max(extract(day from t2.etl_dt))
       end)
when  t1.index_clsaa_s_mcs='盈利情况' then sum(nvl(t2.FTPSYYLJ,0)) end as accu_index_value_m --None
    -- 5
    ,case when t1.index_clsaa_s_mcs='存贷利差情况' then
(case
         when sum(nvl(t2.zhnrjye,0)) = 0 then
          0
         else
          sum(t2.ftplxzcnlj) / sum(t2.zhnrjye) * max(to_char(add_months(trunc(t2.etl_dt, 'YEAR'), 12) - 1, 'DDD')) / max(to_char(t2.etl_dt, 'DDD'))
       end)
when  t1.index_clsaa_s_mcs='盈利情况' then sum(nvl(t2.FTPSYNLJ,0)) end as accu_index_value_y --None
    ,'001' as measure_no                                         --None
    ,'当期值' as index_measure                                      --None
    ,decode(t2.bz,'01','CNY','0A','BWB','FF','BWB') as curr_no   --None
    ,decode(t2.bz,'01','人民币','0A','本外币合计','FF','本外币合计') as curr_name --None
    -- 10
    ,to_date('${batch_date}','yyyymmdd') as etl_dt               --None
    ,TO_TIMESTAMP('${batch_timestamp}','yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp --None
 from itl_edw_pams_jxbb_ckftphz t2 --None 
INNER JOIN mtl_cmm_intnal_org_info t3 --None 
 on substr(t2.ssjgh,1,3) = t3.org_id
   and t3.etl_dt = to_date('${batch_date}','yyyymmdd')
INNER JOIN mc_index_define t1 --None 
 on t1.index_no like 'itl_edw_pams_jxbb_ckftphz%'
 and regexp_like(','||replace(t1.index_no,'itl_edw_pams_jxbb_ckftphz:','')||',',','||t2.cpmc||',')
 and t1.etl_dt=to_date('20250429','yyyymmdd')--固定不改
 and t1.index_clsaa_f_mcs='盈利类'

where t2.etl_dt=to_date('${batch_date}','yyyymmdd')
 and t2.bz in ('01','0A')
GROUP BY t1.index_no_mcs
,t1.index_name_mcs
,substr(t2.ssjgh,1,3)
,t3.org_abbr
,decode(t2.bz,'01','CNY','0A','BWB','FF','BWB')
,decode(t2.bz,'01','人民币','0A','本外币合计','FF','本外币合计')
,t1.index_clsaa_s_mcs
;
commit;


/*==============第60组==============*/

--指标结果表03:绩效报表产品筛选汇总-存款-盈利类-全行
insert into ${idl_schema}.tmp_mc_index_fact_jxkh_ind_result_3(
    index_no_mcs                                                 --指标编号_管驾
    ,index_name_mcs                                              --指标名称_管驾
    ,org_no                                                      --机构编号
    ,org_name                                                    --机构名称
    ,accu_index_value_m                                          --当月值
    -- 5
    ,accu_index_value_y                                          --当年值
    ,measure_no                                                  --度量编号
    ,index_measure                                               --度量名称
    ,curr_no                                                     --币种代码
    ,curr_name                                                   --币种名称
    -- 10
    ,etl_dt                                                      --ETL处理日期
    ,etl_timestamp                                               --ETL处理时间戳
)
select
    t1.index_no_mcs as index_no_mcs                              --None
    ,t1.index_name_mcs as index_name_mcs                         --None
    ,'000000' as org_no                                          --None
    ,'广东华兴银行 ' as org_name                                       --None
    ,case when t1.index_clsaa_s_mcs='存贷利差情况' then
(case
         when sum(nvl(t2.zhyrjye,0)) = 0 then
          0
         else
          sum(t2.ftplxzcylj) / sum(t2.zhyrjye) * max(to_char(add_months(trunc(t2.etl_dt, 'YEAR'), 12) - 1, 'DDD')) / max(extract(day from t2.etl_dt))
       end)
when  t1.index_clsaa_s_mcs='盈利情况' then sum(nvl(t2.FTPSYYLJ,0)) end as accu_index_value_m --None
    -- 5
    ,case when t1.index_clsaa_s_mcs='存贷利差情况' then
(case
         when sum(nvl(t2.zhnrjye,0)) = 0 then
          0
         else
          sum(t2.ftplxzcnlj) / sum(t2.zhnrjye) * max(to_char(add_months(trunc(t2.etl_dt, 'YEAR'), 12) - 1, 'DDD')) / max(to_char(t2.etl_dt, 'DDD'))
       end)
when  t1.index_clsaa_s_mcs='盈利情况' then sum(nvl(t2.FTPSYNLJ,0)) end as accu_index_value_y --None
    ,'001' as measure_no                                         --None
    ,'当期值' as index_measure                                      --None
    ,decode(t2.bz,'01','CNY','0A','BWB','FF','BWB') as curr_no   --None
    ,decode(t2.bz,'01','人民币','0A','本外币合计','FF','本外币合计') as curr_name --None
    -- 10
    ,to_date('${batch_date}','yyyymmdd') as etl_dt               --None
    ,TO_TIMESTAMP('${batch_timestamp}','yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp --None
 from itl_edw_pams_jxbb_ckftphz t2 --None 
INNER JOIN mc_index_define t1 --None 
 on t1.index_no like 'itl_edw_pams_jxbb_ckftphz%'
 and regexp_like(','||replace(t1.index_no,'itl_edw_pams_jxbb_ckftphz:','')||',',','||t2.cpmc||',')
 and t1.etl_dt=to_date('20250429','yyyymmdd')--固定不改
 and t1.index_clsaa_f_mcs='盈利类'

where t2.etl_dt=to_date('${batch_date}','yyyymmdd')
 and t2.bz in ('01','0A')
GROUP BY t1.index_no_mcs
,t1.index_name_mcs
,decode(t2.bz,'01','CNY','0A','BWB','FF','BWB')
,decode(t2.bz,'01','人民币','0A','本外币合计','FF','本外币合计')
,t1.index_clsaa_s_mcs
;
commit;


/*==============第61组==============*/

--指标结果表03:绩效报表产品筛选汇总-存款-盈利类-支行
insert into ${idl_schema}.tmp_mc_index_fact_jxkh_ind_result_3(
    index_no_mcs                                                 --指标编号_管驾
    ,index_name_mcs                                              --指标名称_管驾
    ,org_no                                                      --机构编号
    ,org_name                                                    --机构名称
    ,accu_index_value_m                                          --当月值
    -- 5
    ,accu_index_value_y                                          --当年值
    ,measure_no                                                  --度量编号
    ,index_measure                                               --度量名称
    ,curr_no                                                     --币种代码
    ,curr_name                                                   --币种名称
    -- 10
    ,etl_dt                                                      --ETL处理日期
    ,etl_timestamp                                               --ETL处理时间戳
)
select
    'JX020506131' as index_no_mcs                                --None
    ,'兴惠存FTP净收入' as index_name_mcs                               --None
    ,t2.gsjgdh as org_no                                         --None
    ,t3.org_abbr as org_name                                     --None
    ,sum(t2.ftpsrylj) as accu_index_value_m                      --None
    -- 5
    ,sum(t2.ftpsrnlj) as accu_index_value_y                      --None
    ,'001' as measure_no                                         --None
    ,'当期值' as index_measure                                      --None
    ,'BWB' as curr_no                                            --None
    ,'本外币合计' as curr_name                                        --None
    -- 10
    ,to_date('${batch_date}','yyyymmdd') as etl_dt               --None
    ,TO_TIMESTAMP('${batch_timestamp}','yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp --None
 from itl_edw_pams_jxbb_ckftpmx t2 --None 
INNER JOIN mtl_cmm_intnal_org_info t3 --None 
 on t2.gsjgdh = t3.org_id
   and t3.etl_dt = to_date('${batch_date}','yyyymmdd')
INNER JOIN itl_edw_cmm_dep_acct_attach_info t4 --None 
 on t4.etl_dt=to_date('${batch_date}','yyyymmdd')
 and t2.zhdh=t4.acct_id
 and t4.xhc_flg = '1'

where t2.etl_dt=to_date('${batch_date}','yyyymmdd')
 and length(t2.gsjgdh)>3
 and t2.gsjgdh<>'000000'
GROUP BY t2.gsjgdh
,t3.org_abbr
;
commit;


/*==============第62组==============*/

--指标结果表03:绩效报表产品筛选汇总-存款-盈利类-分行
insert into ${idl_schema}.tmp_mc_index_fact_jxkh_ind_result_3(
    index_no_mcs                                                 --指标编号_管驾
    ,index_name_mcs                                              --指标名称_管驾
    ,org_no                                                      --机构编号
    ,org_name                                                    --机构名称
    ,accu_index_value_m                                          --当月值
    -- 5
    ,accu_index_value_y                                          --当年值
    ,measure_no                                                  --度量编号
    ,index_measure                                               --度量名称
    ,curr_no                                                     --币种代码
    ,curr_name                                                   --币种名称
    -- 10
    ,etl_dt                                                      --ETL处理日期
    ,etl_timestamp                                               --ETL处理时间戳
)
select
    'JX020506131' as index_no_mcs                                --None
    ,'兴惠存FTP净收入' as index_name_mcs                               --None
    ,substr(t2.gsjgdh,1,3) as org_no                             --None
    ,t3.org_abbr as org_name                                     --None
    ,sum(t2.ftpsrylj) as accu_index_value_m                      --None
    -- 5
    ,sum(t2.ftpsrnlj) as accu_index_value_y                      --None
    ,'001' as measure_no                                         --None
    ,'当期值' as index_measure                                      --None
    ,'BWB' as curr_no                                            --None
    ,'本外币合计' as curr_name                                        --None
    -- 10
    ,to_date('${batch_date}','yyyymmdd') as etl_dt               --None
    ,TO_TIMESTAMP('${batch_timestamp}','yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp --None
 from itl_edw_pams_jxbb_ckftpmx t2 --None 
INNER JOIN mtl_cmm_intnal_org_info t3 --None 
 on substr(t2.gsjgdh,1,3) = t3.org_id
   and t3.etl_dt = to_date('${batch_date}','yyyymmdd')
INNER JOIN itl_edw_cmm_dep_acct_attach_info t4 --None 
 on t4.etl_dt=to_date('${batch_date}','yyyymmdd')
 and t2.zhdh=t4.acct_id
 and t4.xhc_flg = '1'

where t2.etl_dt=to_date('${batch_date}','yyyymmdd')
GROUP BY substr(t2.gsjgdh,1,3)
,t3.org_abbr
;
commit;


/*==============第63组==============*/

--指标结果表03:绩效报表产品筛选汇总-存款-盈利类-全行
insert into ${idl_schema}.tmp_mc_index_fact_jxkh_ind_result_3(
    index_no_mcs                                                 --指标编号_管驾
    ,index_name_mcs                                              --指标名称_管驾
    ,org_no                                                      --机构编号
    ,org_name                                                    --机构名称
    ,accu_index_value_m                                          --当月值
    -- 5
    ,accu_index_value_y                                          --当年值
    ,measure_no                                                  --度量编号
    ,index_measure                                               --度量名称
    ,curr_no                                                     --币种代码
    ,curr_name                                                   --币种名称
    -- 10
    ,etl_dt                                                      --ETL处理日期
    ,etl_timestamp                                               --ETL处理时间戳
)
select
    'JX020506131' as index_no_mcs                                --None
    ,'兴惠存FTP净收入' as index_name_mcs                               --None
    ,'000000' as org_no                                          --None
    ,'广东华兴银行 ' as org_name                                       --None
    ,sum(t2.ftpsrylj) as accu_index_value_m                      --None
    -- 5
    ,sum(t2.ftpsrnlj) as accu_index_value_y                      --None
    ,'001' as measure_no                                         --None
    ,'当期值' as index_measure                                      --None
    ,'BWB' as curr_no                                            --None
    ,'本外币合计' as curr_name                                        --None
    -- 10
    ,to_date('${batch_date}','yyyymmdd') as etl_dt               --None
    ,TO_TIMESTAMP('${batch_timestamp}','yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp --None
 from itl_edw_pams_jxbb_ckftpmx t2 --None 
INNER JOIN itl_edw_cmm_dep_acct_attach_info t4 --None 
 on t4.etl_dt=to_date('${batch_date}','yyyymmdd')
 and t2.zhdh=t4.acct_id
 and t4.xhc_flg = '1'

where t2.etl_dt=to_date('${batch_date}','yyyymmdd')
 
;
commit;


/*==============第64组==============*/

--指标结果表03:绩效报表产品筛选汇总-存款-盈利类-支行
insert into ${idl_schema}.tmp_mc_index_fact_jxkh_ind_result_3(
    index_no_mcs                                                 --指标编号_管驾
    ,index_name_mcs                                              --指标名称_管驾
    ,org_no                                                      --机构编号
    ,org_name                                                    --机构名称
    ,accu_index_value_m                                          --当月值
    -- 5
    ,accu_index_value_y                                          --当年值
    ,measure_no                                                  --度量编号
    ,index_measure                                               --度量名称
    ,curr_no                                                     --币种代码
    ,curr_name                                                   --币种名称
    -- 10
    ,etl_dt                                                      --ETL处理日期
    ,etl_timestamp                                               --ETL处理时间戳
)
select
    'JX020104082' as index_no_mcs                                --None
    ,'兴惠存付息率' as index_name_mcs                                  --None
    ,t2.gsjgdh as org_no                                         --None
    ,t3.org_abbr as org_name                                     --None
    ,case
         when sum(nvl(t5.index_value,0)) = 0 then
          0
         else
          sum(t2.ftplxzcylj) / sum(t5.index_value) * max(to_char(add_months(trunc(t2.etl_dt, 'YEAR'), 12) - 1, 'DDD')) / max(extract(day from t2.etl_dt))
       end as accu_index_value_m --None
    -- 5
    ,case
         when sum(nvl(t6.index_value,0)) = 0 then
          0
         else
          sum(t2.ftplxzcnlj) / sum(t6.index_value) * max(to_char(add_months(trunc(t2.etl_dt, 'YEAR'), 12) - 1, 'DDD')) / max(to_char(t2.etl_dt, 'DDD'))
       end as accu_index_value_y --None
    ,'001' as measure_no                                         --None
    ,'当期值' as index_measure                                      --None
    ,'BWB' as curr_no                                            --None
    ,'本外币合计' as curr_name                                        --None
    -- 10
    ,to_date('${batch_date}','yyyymmdd') as etl_dt               --None
    ,TO_TIMESTAMP('${batch_timestamp}','yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp --None
 from itl_edw_pams_jxbb_ckftpmx t2 --None 
INNER JOIN mtl_cmm_intnal_org_info t3 --None 
 on t2.gsjgdh = t3.org_id
   and t3.etl_dt = to_date('${batch_date}','yyyymmdd')
INNER JOIN itl_edw_cmm_dep_acct_attach_info t4 --None 
 on t4.etl_dt=to_date('${batch_date}','yyyymmdd')
 and t2.zhdh=t4.acct_id
 and t4.xhc_flg = '1'
LEFT JOIN tmp_mc_index_fact_jxkh_ind_result_1 t5 --None 
 on t5.index_no_mcs='JX010203030'
and t5.org_no=t3.org_id
and t5.measure_no='002'
LEFT JOIN tmp_mc_index_fact_jxkh_ind_result_1 t6 --None 
 on t6.index_no_mcs='JX010203030'
and t6.org_no=t3.org_id
and t6.measure_no='004'

where t2.etl_dt=to_date('${batch_date}','yyyymmdd')
 and length(t2.gsjgdh)>3
 and t2.gsjgdh<>'000000'
GROUP BY t2.gsjgdh
,t3.org_abbr
;
commit;


/*==============第65组==============*/

--指标结果表03:绩效报表产品筛选汇总-存款-盈利类-分行
insert into ${idl_schema}.tmp_mc_index_fact_jxkh_ind_result_3(
    index_no_mcs                                                 --指标编号_管驾
    ,index_name_mcs                                              --指标名称_管驾
    ,org_no                                                      --机构编号
    ,org_name                                                    --机构名称
    ,accu_index_value_m                                          --当月值
    -- 5
    ,accu_index_value_y                                          --当年值
    ,measure_no                                                  --度量编号
    ,index_measure                                               --度量名称
    ,curr_no                                                     --币种代码
    ,curr_name                                                   --币种名称
    -- 10
    ,etl_dt                                                      --ETL处理日期
    ,etl_timestamp                                               --ETL处理时间戳
)
select
    'JX020104082' as index_no_mcs                                --None
    ,'兴惠存付息率' as index_name_mcs                                  --None
    ,t2.org_id as org_no                                         --None
    ,t3.org_abbr as org_name                                     --None
    ,case
         when sum(nvl(t5.index_value,0)) = 0 then
          0
         else
          sum(t2.ftplxzcylj) / sum(t5.index_value) * max(to_char(add_months(trunc(t2.etl_dt, 'YEAR'), 12) - 1, 'DDD')) / max(extract(day from t2.etl_dt))
       end as accu_index_value_m --None
    -- 5
    ,case
         when sum(nvl(t6.index_value,0)) = 0 then
          0
         else
          sum(t2.ftplxzcnlj) / sum(t6.index_value) * max(to_char(add_months(trunc(t2.etl_dt, 'YEAR'), 12) - 1, 'DDD')) / max(to_char(t2.etl_dt, 'DDD'))
       end as accu_index_value_y --None
    ,'001' as measure_no                                         --None
    ,'当期值' as index_measure                                      --None
    ,'BWB' as curr_no                                            --None
    ,'本外币合计' as curr_name                                        --None
    -- 10
    ,to_date('${batch_date}','yyyymmdd') as etl_dt               --None
    ,TO_TIMESTAMP('${batch_timestamp}','yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp --None
 from (select substr(t2.gsjgdh,1,3) as org_id,
        sum(t2.ftplxzcylj) as ftplxzcylj,
        sum(t2.ftplxzcnlj) as ftplxzcnlj,
        t2.etl_dt
   from itl_edw_pams_jxbb_ckftpmx t2
 inner join itl_edw_cmm_dep_acct_attach_info t4
  on t4.etl_dt=to_date('${batch_date}','yyyymmdd')
 and t2.zhdh=t4.acct_id
 and t4.xhc_flg = '1'
where t2.etl_dt=to_date('${batch_date}','yyyymmdd')
 group by substr(t2.gsjgdh,1,3),t2.etl_dt) t2 --None 
INNER JOIN mtl_cmm_intnal_org_info t3 --None 
 on t2.org_id= t3.org_id
   and t3.etl_dt = to_date('${batch_date}','yyyymmdd')
LEFT JOIN tmp_mc_index_fact_jxkh_ind_result_1 t5 --None 
 on t5.index_no_mcs='JX010203030'
and t5.org_no=t3.org_id
and t5.measure_no='002'
LEFT JOIN tmp_mc_index_fact_jxkh_ind_result_1 t6 --None 
 on t6.index_no_mcs='JX010203030'
and t6.org_no=t3.org_id
and t6.measure_no='004'

 
GROUP BY t2.org_id
,t3.org_abbr
;
commit;


/*==============第66组==============*/

--指标结果表03:绩效报表产品筛选汇总-存款-盈利类-全行
insert into ${idl_schema}.tmp_mc_index_fact_jxkh_ind_result_3(
    index_no_mcs                                                 --指标编号_管驾
    ,index_name_mcs                                              --指标名称_管驾
    ,org_no                                                      --机构编号
    ,org_name                                                    --机构名称
    ,accu_index_value_m                                          --当月值
    -- 5
    ,accu_index_value_y                                          --当年值
    ,measure_no                                                  --度量编号
    ,index_measure                                               --度量名称
    ,curr_no                                                     --币种代码
    ,curr_name                                                   --币种名称
    -- 10
    ,etl_dt                                                      --ETL处理日期
    ,etl_timestamp                                               --ETL处理时间戳
)
select
    'JX020104082' as index_no_mcs                                --None
    ,'兴惠存付息率' as index_name_mcs                                  --None
    ,'000000' as org_no                                          --None
    ,'广东华兴银行 ' as org_name                                       --None
    ,case
         when sum(nvl(t5.index_value,0)) = 0 then
          0
         else
          sum(t2.ftplxzcylj) / sum(t5.index_value) * max(to_char(add_months(trunc(t2.etl_dt, 'YEAR'), 12) - 1, 'DDD')) / max(extract(day from t2.etl_dt))
       end as accu_index_value_m --None
    -- 5
    ,case
         when sum(nvl(t6.index_value,0)) = 0 then
          0
         else
          sum(t2.ftplxzcnlj) / sum(t6.index_value) * max(to_char(add_months(trunc(t2.etl_dt, 'YEAR'), 12) - 1, 'DDD')) / max(to_char(t2.etl_dt, 'DDD'))
       end as accu_index_value_y --None
    ,'001' as measure_no                                         --None
    ,'当期值' as index_measure                                      --None
    ,'BWB' as curr_no                                            --None
    ,'本外币合计' as curr_name                                        --None
    -- 10
    ,to_date('${batch_date}','yyyymmdd') as etl_dt               --None
    ,TO_TIMESTAMP('${batch_timestamp}','yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp --None
 from (select '000000' as org_id,
        sum(t2.ftplxzcylj) as ftplxzcylj,
        sum(t2.ftplxzcnlj) as ftplxzcnlj,
        t2.etl_dt
   from itl_edw_pams_jxbb_ckftpmx t2
 inner join itl_edw_cmm_dep_acct_attach_info t4
  on t4.etl_dt=to_date('${batch_date}','yyyymmdd')
 and t2.zhdh=t4.acct_id
 and t4.xhc_flg = '1'
where t2.etl_dt=to_date('${batch_date}','yyyymmdd')
 group by t2.etl_dt) t2 --None 
LEFT JOIN tmp_mc_index_fact_jxkh_ind_result_1 t5 --None 
 on t5.index_no_mcs='JX010203030'
and t5.org_no='000000'
and t5.measure_no='002'
and t5.etl_dt=t2.etl_dt
LEFT JOIN tmp_mc_index_fact_jxkh_ind_result_1 t6 --None 
 on t6.index_no_mcs='JX010203030'
and t6.org_no='000000'
and t6.measure_no='004'
and t6.etl_dt=t2.etl_dt

where t2.etl_dt=to_date('${batch_date}','yyyymmdd')
 
;
commit;


/*==============第67组==============*/

--指标结果表03:同业存单明细汇总-同业存单付息率
insert into ${idl_schema}.tmp_mc_index_fact_jxkh_ind_result_3(
    index_no_mcs                                                 --指标编号_管驾
    ,index_name_mcs                                              --指标名称_管驾
    ,org_no                                                      --机构编号
    ,org_name                                                    --机构名称
    ,accu_index_value_m                                          --当月值
    -- 5
    ,accu_index_value_y                                          --当年值
    ,measure_no                                                  --度量编号
    ,index_measure                                               --度量名称
    ,curr_no                                                     --币种代码
    ,curr_name                                                   --币种名称
    -- 10
    ,etl_dt                                                      --ETL处理日期
    ,etl_timestamp                                               --ETL处理时间戳
)
select
    'JX020302109' as index_no_mcs                                --None
    ,'同业存单付息率' as index_name_mcs                                 --None
    ,'896821' as org_no                                          --None
    ,'' as org_name                                              --None
    ,sum(nvl(t2.ftplxsrylj,0))/sum(nvl(t2.yrj,0))* max(to_char(add_months(trunc(t2.etl_dt, 'YEAR'), 12) - 1, 'DDD')) / max(extract(day from t2.etl_dt)) as accu_index_value_m --None
    -- 5
    ,sum(nvl(t2.ftplxsrnlj,0))/sum(nvl(t2.nrj,0))* max(to_char(add_months(trunc(t2.etl_dt, 'YEAR'), 12) - 1, 'DDD')) / max(to_char(t2.etl_dt, 'DDD')) as accu_index_value_y --None
    ,'001' as measure_no                                         --None
    ,'当前值' as index_measure                                      --None
    ,'BWB' as curr_no                                            --None
    ,'本外币合计' as curr_name                                        --None
    -- 10
    ,to_date('${batch_date}','yyyymmdd') as etl_dt               --None
    ,TO_TIMESTAMP('${batch_timestamp}','yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp --None
 from itl_edw_pams_jxbb_tycdmx t2 --None 

where t2.etl_dt=to_date('${batch_date}','yyyymmdd')
and t2.ssjgmc like '%资金交易部%'
and t2.tjrq = '${batch_date}'
and t2.FPJS='1'
 
;
commit;


/*==============第68组==============*/

--指标结果表01:自算-规模类
insert into ${idl_schema}.tmp_mc_index_fact_jxkh_ind_result_1(
    index_no_mcs                                                 --指标编号_管驾
    ,index_name_mcs                                              --指标名称_管驾
    ,org_no                                                      --机构编号
    ,org_name                                                    --机构名称
    ,index_value                                                 --指标值
    -- 5
    ,measure_no                                                  --度量编号
    ,index_measure                                               --度量名称
    ,curr_no                                                     --币种代码
    ,curr_name                                                   --币种名称
    ,etl_dt                                                      --ETL处理日期
    -- 10
    ,etl_timestamp                                               --ETL处理时间戳
)
select
    'JX030202206' as index_no_mcs                                --None
    ,'其他' as index_name_mcs                                      --None
    ,t1.org_no as org_no                                         --None
    ,'' as org_name                                              --None
    ,sum(case when t1.index_no_mcs<>'JX030201203' then 0-nvl(t1.index_value,0) else nvl(t1.index_value,0) end ) as index_value --None
    -- 5
    ,t1.MEASURE_NO as measure_no                                 --None
    ,t1.INDEX_MEASURE as index_measure                           --None
    ,t1.CURR_NO as curr_no                                       --None
    ,t1.CURR_NAME as curr_name                                   --None
    ,to_date('${batch_date}','yyyymmdd') as etl_dt               --None
    -- 10
    ,TO_TIMESTAMP('${batch_timestamp}','yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp --None
 from tmp_mc_index_fact_jxkh_ind_result_1 t1 --None 

where t1.index_no_mcs in ('JX030201203','JX030202204','JX030202205')
GROUP BY t1.org_no
,t1.measure_no
,t1.index_measure
,t1.curr_no
,t1.curr_name
;
commit;


/*==============第69组==============*/

--指标结果表01:自算-规模类
insert into ${idl_schema}.tmp_mc_index_fact_jxkh_ind_result_1(
    index_no_mcs                                                 --指标编号_管驾
    ,index_name_mcs                                              --指标名称_管驾
    ,org_no                                                      --机构编号
    ,org_name                                                    --机构名称
    ,index_value                                                 --指标值
    -- 5
    ,measure_no                                                  --度量编号
    ,index_measure                                               --度量名称
    ,curr_no                                                     --币种代码
    ,curr_name                                                   --币种名称
    ,etl_dt                                                      --ETL处理日期
    -- 10
    ,etl_timestamp                                               --ETL处理时间戳
)
select
    'JX010401050' as index_no_mcs                                --None
    ,'不良资产额' as index_name_mcs                                   --None
    ,t1.org_no as org_no                                         --None
    ,'' as org_name                                              --None
    ,sum(nvl(t1.index_value,0)) as index_value                   --None
    -- 5
    ,t1.MEASURE_NO as measure_no                                 --None
    ,t1.INDEX_MEASURE as index_measure                           --None
    ,t1.CURR_NO as curr_no                                       --None
    ,t1.CURR_NAME as curr_name                                   --None
    ,to_date('${batch_date}','yyyymmdd') as etl_dt               --None
    -- 10
    ,TO_TIMESTAMP('${batch_timestamp}','yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp --None
 from tmp_mc_index_fact_jxkh_ind_result_1 t1 --None 

where t1.index_no_mcs in ('JX010402051','JX010402052','JX010402056','JX010402057')
GROUP BY t1.org_no
,t1.measure_no
,t1.index_measure
,t1.curr_no
,t1.curr_name
;
commit;


/*==============第70组==============*/

--指标结果表01:自算-规模类
insert into ${idl_schema}.tmp_mc_index_fact_jxkh_ind_result_1(
    index_no_mcs                                                 --指标编号_管驾
    ,index_name_mcs                                              --指标名称_管驾
    ,org_no                                                      --机构编号
    ,org_name                                                    --机构名称
    ,index_value                                                 --指标值
    -- 5
    ,measure_no                                                  --度量编号
    ,index_measure                                               --度量名称
    ,curr_no                                                     --币种代码
    ,curr_name                                                   --币种名称
    ,etl_dt                                                      --ETL处理日期
    -- 10
    ,etl_timestamp                                               --ETL处理时间戳
)
select
    'JX010102022' as index_no_mcs                                --None
    ,'其他资产规模' as index_name_mcs                                  --None
    ,t1.org_no as org_no                                         --None
    ,'' as org_name                                              --None
    ,sum(case when t1.index_no_mcs='JX010101018' then nvl(t1.index_value,0) else 0-nvl(t1.index_value,0) end) as index_value --None
    -- 5
    ,t1.MEASURE_NO as measure_no                                 --None
    ,t1.INDEX_MEASURE as index_measure                           --None
    ,t1.CURR_NO as curr_no                                       --None
    ,t1.CURR_NAME as curr_name                                   --None
    ,to_date('${batch_date}','yyyymmdd') as etl_dt               --None
    -- 10
    ,TO_TIMESTAMP('${batch_timestamp}','yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp --None
 from tmp_mc_index_fact_jxkh_ind_result_1 t1 --None 

where t1.index_no_mcs in ('JX010101018','JX010102019','JX010102020','JX010102021')
and t1.org_no='896821'
GROUP BY t1.org_no
,t1.measure_no
,t1.index_measure
,t1.curr_no
,t1.curr_name
;
commit;


/*==============第71组==============*/

--指标结果表01:自算-规模类
insert into ${idl_schema}.tmp_mc_index_fact_jxkh_ind_result_1(
    index_no_mcs                                                 --指标编号_管驾
    ,index_name_mcs                                              --指标名称_管驾
    ,org_no                                                      --机构编号
    ,org_name                                                    --机构名称
    ,index_value                                                 --指标值
    -- 5
    ,measure_no                                                  --度量编号
    ,index_measure                                               --度量名称
    ,curr_no                                                     --币种代码
    ,curr_name                                                   --币种名称
    ,etl_dt                                                      --ETL处理日期
    -- 10
    ,etl_timestamp                                               --ETL处理时间戳
)
select
    'JX010202041' as index_no_mcs                                --None
    ,'其他负债规模' as index_name_mcs                                  --None
    ,t1.org_no as org_no                                         --None
    ,'' as org_name                                              --None
    ,sum(case when t1.index_no_mcs='JX010201038' then nvl(t1.index_value,0) else 0-nvl(t1.index_value,0) end) as index_value --None
    -- 5
    ,t1.MEASURE_NO as measure_no                                 --None
    ,t1.INDEX_MEASURE as index_measure                           --None
    ,t1.CURR_NO as curr_no                                       --None
    ,t1.CURR_NAME as curr_name                                   --None
    ,to_date('${batch_date}','yyyymmdd') as etl_dt               --None
    -- 10
    ,TO_TIMESTAMP('${batch_timestamp}','yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp --None
 from tmp_mc_index_fact_jxkh_ind_result_1 t1 --None 

where t1.index_no_mcs in ('JX010201038','JX010202039','JX010202040')
and t1.org_no='896821'
GROUP BY t1.org_no
,t1.measure_no
,t1.index_measure
,t1.curr_no
,t1.curr_name
;
commit;


/*==============第72组==============*/

--指标结果表01:自算-规模类-计算产品的不良贷款率
insert into ${idl_schema}.tmp_mc_index_fact_jxkh_ind_result_1(
    index_no_mcs                                                 --指标编号_管驾
    ,index_name_mcs                                              --指标名称_管驾
    ,org_no                                                      --机构编号
    ,org_name                                                    --机构名称
    ,index_value                                                 --指标值
    -- 5
    ,measure_no                                                  --度量编号
    ,index_measure                                               --度量名称
    ,curr_no                                                     --币种代码
    ,curr_name                                                   --币种名称
    ,etl_dt                                                      --ETL处理日期
    -- 10
    ,etl_timestamp                                               --ETL处理时间戳
)
select
    t2.index_no_mcs as index_no_mcs                              --None
    ,t2.INDEX_NAME_MCS as index_name_mcs                         --None
    ,t1.org_no as org_no                                         --None
    ,'' as org_name                                              --None
    ,sum(case when nvl(t3.index_value,0)=0 then 0 else t1.index_value/t3.index_value end) as index_value --None
    -- 5
    ,t1.MEASURE_NO as measure_no                                 --None
    ,t1.INDEX_MEASURE as index_measure                           --None
    ,t1.CURR_NO as curr_no                                       --None
    ,t1.CURR_NAME as curr_name                                   --None
    ,to_date('${batch_date}','yyyymmdd') as etl_dt               --None
    -- 10
    ,TO_TIMESTAMP('${batch_timestamp}','yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp --None
 from tmp_mc_index_fact_jxkh_ind_result_1 t1 --None 
INNER JOIN mc_index_define t2 --None 
 on decode(t1.index_no_mcs,'JX010403053','JX010403061','JX010403054','JX010403062','JX010403055','JX010403063') =t2.index_no_mcs
 and t2.etl_dt=to_date('20250429','yyyymmdd')--固定不改
 and t2.index_clsaa_f_mcs<>'盈利类'
INNER JOIN tmp_mc_index_fact_jxkh_ind_result_1 t3 --None 
 on t3.index_no_mcs=decode(t1.index_no_mcs,'JX010403053','JX010104012','JX010403054','JX010104013','JX010403055','JX010104018')
and t3.org_no=t1.org_no
and t3.measure_no='001'
and t3.curr_no=t1.curr_no

where t1.index_no_mcs in ('JX010403053','JX010403054','JX010403055')
GROUP BY t2.index_no_mcs
,t2.index_name_mcs
,t1.org_no
,t1.measure_no
,t1.index_measure
,t1.curr_no
,t1.curr_name
;
commit;


/*==============第73组==============*/

--指标结果表03:自算-盈利类-1
insert into ${idl_schema}.tmp_mc_index_fact_jxkh_ind_result_3(
    index_no_mcs                                                 --指标编号_管驾
    ,index_name_mcs                                              --指标名称_管驾
    ,org_no                                                      --机构编号
    ,org_name                                                    --机构名称
    ,accu_index_value_m                                          --当月值
    -- 5
    ,accu_index_value_y                                          --当年值
    ,measure_no                                                  --度量编号
    ,index_measure                                               --度量名称
    ,curr_no                                                     --币种代码
    ,curr_name                                                   --币种名称
    -- 10
    ,etl_dt                                                      --ETL处理日期
    ,etl_timestamp                                               --ETL处理时间戳
)
select
    'JX020102071' as index_no_mcs                                --None
    ,'贷款收息率' as index_name_mcs                                   --None
    ,t1.org_no as org_no                                         --None
    ,'' as org_name                                              --None
    ,case
         when sum(t2.index_value) = 0 then
          0
         else
          sum(t1.accu_index_value_m) / (sum(t2.index_value) * max(to_char(add_months(trunc(t2.etl_dt, 'YEAR'), 12) - 1, 'DDD'))) / max(extract(day from t2.etl_dt))
       end as accu_index_value_m --None
    -- 5
    ,case
         when sum(t3.index_value) = 0 then
          0
         else
          sum(t1.accu_index_value_y) / (sum(t3.index_value) * max(to_char(add_months(trunc(t2.etl_dt, 'YEAR'), 12) - 1, 'DDD'))) / max(to_char(t2.etl_dt, 'DDD'))
       end as accu_index_value_y --None
    ,t1.MEASURE_NO as measure_no                                 --None
    ,t1.INDEX_MEASURE as index_measure                           --None
    ,t1.CURR_NO as curr_no                                       --None
    ,t1.CURR_NAME as curr_name                                   --None
    -- 10
    ,to_date('${batch_date}','yyyymmdd') as etl_dt               --None
    ,TO_TIMESTAMP('${batch_timestamp}','yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp --None
 from tmp_mc_index_fact_jxkh_ind_result_3 t1 --None 
INNER JOIN (select org_no,curr_no,sum(index_value) as index_value,etl_dt
from tmp_mc_index_fact_jxkh_ind_result_1
where index_no_mcs in ('JX010101001','JX010102009')
and measure_no='002'
group by org_no,curr_no,etl_dt) t2 --None 
 on t1.org_no=t2.org_no
and t1.curr_no=t2.curr_no
INNER JOIN (select org_no,curr_no,sum(index_value) as index_value,etl_dt
from tmp_mc_index_fact_jxkh_ind_result_1
where index_no_mcs in ('JX010101001','JX010102009')
and measure_no='004'
group by org_no,curr_no,etl_dt) t3 --None 
 on t1.org_no=t3.org_no
and t1.curr_no=t3.curr_no

where t1.index_no_mcs in ('JX020504135','JX020504156')
GROUP BY t1.org_no
,t1.measure_no
,t1.index_measure
,t1.curr_no
,t1.curr_name
;
commit;


/*==============第74组==============*/

--指标结果表03:自算-盈利类-1
insert into ${idl_schema}.tmp_mc_index_fact_jxkh_ind_result_3(
    index_no_mcs                                                 --指标编号_管驾
    ,index_name_mcs                                              --指标名称_管驾
    ,org_no                                                      --机构编号
    ,org_name                                                    --机构名称
    ,accu_index_value_m                                          --当月值
    -- 5
    ,accu_index_value_y                                          --当年值
    ,measure_no                                                  --度量编号
    ,index_measure                                               --度量名称
    ,curr_no                                                     --币种代码
    ,curr_name                                                   --币种名称
    -- 10
    ,etl_dt                                                      --ETL处理日期
    ,etl_timestamp                                               --ETL处理时间戳
)
select
    'JX020102072' as index_no_mcs                                --None
    ,'存款付息率' as index_name_mcs                                   --None
    ,t1.org_no as org_no                                         --None
    ,'' as org_name                                              --None
    ,case
         when sum(t2.index_value) = 0 then
          0
         else
          sum(t1.accu_index_value_m) / (sum(t2.index_value) * max(to_char(add_months(trunc(t2.etl_dt, 'YEAR'), 12) - 1, 'DDD'))) / max(extract(day from t2.etl_dt))
       end as accu_index_value_m --None
    -- 5
    ,case
         when sum(t3.index_value) = 0 then
          0
         else
          sum(t1.accu_index_value_y) / (sum(t3.index_value) * max(to_char(add_months(trunc(t2.etl_dt, 'YEAR'), 12) - 1, 'DDD'))) / max(to_char(t2.etl_dt, 'DDD'))
       end as accu_index_value_y --None
    ,t1.MEASURE_NO as measure_no                                 --None
    ,t1.INDEX_MEASURE as index_measure                           --None
    ,t1.CURR_NO as curr_no                                       --None
    ,t1.CURR_NAME as curr_name                                   --None
    -- 10
    ,to_date('${batch_date}','yyyymmdd') as etl_dt               --None
    ,TO_TIMESTAMP('${batch_timestamp}','yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp --None
 from tmp_mc_index_fact_jxkh_ind_result_3 t1 --None 
INNER JOIN (select org_no,curr_no,sum(index_value) as index_value,etl_dt
from tmp_mc_index_fact_jxkh_ind_result_1
where index_no_mcs in ('JX010201028','JX010201033')
and measure_no='002'
group by org_no,curr_no,etl_dt) t2 --None 
 on t1.org_no=t2.org_no
and t1.curr_no=t2.curr_no
INNER JOIN (select org_no,curr_no,sum(index_value) as index_value,etl_dt
from tmp_mc_index_fact_jxkh_ind_result_1
where index_no_mcs in ('JX010201028','JX010201033')
and measure_no='004'
group by org_no,curr_no,etl_dt) t3 --None 
 on t1.org_no=t3.org_no
and t1.curr_no=t3.curr_no

where t1.index_no_mcs in ('JX020504129','JX020504150')
GROUP BY t1.org_no
,t1.measure_no
,t1.index_measure
,t1.curr_no
,t1.curr_name
;
commit;


/*==============第75组==============*/

--指标结果表03:自算-盈利类-1
insert into ${idl_schema}.tmp_mc_index_fact_jxkh_ind_result_3(
    index_no_mcs                                                 --指标编号_管驾
    ,index_name_mcs                                              --指标名称_管驾
    ,org_no                                                      --机构编号
    ,org_name                                                    --机构名称
    ,accu_index_value_m                                          --当月值
    -- 5
    ,accu_index_value_y                                          --当年值
    ,measure_no                                                  --度量编号
    ,index_measure                                               --度量名称
    ,curr_no                                                     --币种代码
    ,curr_name                                                   --币种名称
    -- 10
    ,etl_dt                                                      --ETL处理日期
    ,etl_timestamp                                               --ETL处理时间戳
)
select
    'JX020102074' as index_no_mcs                                --None
    ,'对公贷款收息率' as index_name_mcs                                 --None
    ,t1.org_no as org_no                                         --None
    ,'' as org_name                                              --None
    ,case
         when sum(t2.index_value) = 0 then
          0
         else
          sum(t1.accu_index_value_m) / (sum(t2.index_value) * max(to_char(add_months(trunc(t2.etl_dt, 'YEAR'), 12) - 1, 'DDD'))) / max(extract(day from t2.etl_dt))
       end as accu_index_value_m --None
    -- 5
    ,case
         when sum(t3.index_value) = 0 then
          0
         else
          sum(t1.accu_index_value_y) / (sum(t3.index_value) * max(to_char(add_months(trunc(t2.etl_dt, 'YEAR'), 12) - 1, 'DDD'))) / max(to_char(t2.etl_dt, 'DDD'))
       end as accu_index_value_y --None
    ,t1.MEASURE_NO as measure_no                                 --None
    ,t1.INDEX_MEASURE as index_measure                           --None
    ,t1.CURR_NO as curr_no                                       --None
    ,t1.CURR_NAME as curr_name                                   --None
    -- 10
    ,to_date('${batch_date}','yyyymmdd') as etl_dt               --None
    ,TO_TIMESTAMP('${batch_timestamp}','yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp --None
 from tmp_mc_index_fact_jxkh_ind_result_3 t1 --None 
INNER JOIN tmp_mc_index_fact_jxkh_ind_result_1 t2 --None 
 on t2.index_no_mcs in ('JX010101001','')
and t1.org_no=t2.org_no
and t2.measure_no='002'
and t1.curr_no=t2.curr_no
INNER JOIN tmp_mc_index_fact_jxkh_ind_result_1 t3 --None 
 on t3.index_no_mcs in ('JX010101001','')
and t1.org_no=t3.org_no
and t3.measure_no='004'
and t1.curr_no=t3.curr_no

where t1.index_no_mcs in ('JX020504135','')
GROUP BY t1.org_no
,t1.measure_no
,t1.index_measure
,t1.curr_no
,t1.curr_name
;
commit;


/*==============第76组==============*/

--指标结果表03:自算-盈利类-1
insert into ${idl_schema}.tmp_mc_index_fact_jxkh_ind_result_3(
    index_no_mcs                                                 --指标编号_管驾
    ,index_name_mcs                                              --指标名称_管驾
    ,org_no                                                      --机构编号
    ,org_name                                                    --机构名称
    ,accu_index_value_m                                          --当月值
    -- 5
    ,accu_index_value_y                                          --当年值
    ,measure_no                                                  --度量编号
    ,index_measure                                               --度量名称
    ,curr_no                                                     --币种代码
    ,curr_name                                                   --币种名称
    -- 10
    ,etl_dt                                                      --ETL处理日期
    ,etl_timestamp                                               --ETL处理时间戳
)
select
    'JX020102080' as index_no_mcs                                --None
    ,'对公存款付息率' as index_name_mcs                                 --None
    ,t1.org_no as org_no                                         --None
    ,'' as org_name                                              --None
    ,case
         when sum(t2.index_value) = 0 then
          0
         else
          sum(t1.accu_index_value_m) / (sum(t2.index_value) * max(to_char(add_months(trunc(t2.etl_dt, 'YEAR'), 12) - 1, 'DDD'))) / max(extract(day from t2.etl_dt))
       end as accu_index_value_m --None
    -- 5
    ,case
         when sum(t3.index_value) = 0 then
          0
         else
          sum(t1.accu_index_value_y) / (sum(t3.index_value) * max(to_char(add_months(trunc(t2.etl_dt, 'YEAR'), 12) - 1, 'DDD'))) / max(to_char(t2.etl_dt, 'DDD'))
       end as accu_index_value_y --None
    ,t1.MEASURE_NO as measure_no                                 --None
    ,t1.INDEX_MEASURE as index_measure                           --None
    ,t1.CURR_NO as curr_no                                       --None
    ,t1.CURR_NAME as curr_name                                   --None
    -- 10
    ,to_date('${batch_date}','yyyymmdd') as etl_dt               --None
    ,TO_TIMESTAMP('${batch_timestamp}','yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp --None
 from tmp_mc_index_fact_jxkh_ind_result_3 t1 --None 
INNER JOIN tmp_mc_index_fact_jxkh_ind_result_1 t2 --None 
 on t2.index_no_mcs in ('JX010201028','')
and t1.org_no=t2.org_no
and t2.measure_no='002'
and t1.curr_no=t2.curr_no
INNER JOIN tmp_mc_index_fact_jxkh_ind_result_1 t3 --None 
 on t3.index_no_mcs in ('JX010201028','')
and t1.org_no=t3.org_no
and t3.measure_no='004'
and t1.curr_no=t3.curr_no

where t1.index_no_mcs in ('JX020504129','')
GROUP BY t1.org_no
,t1.measure_no
,t1.index_measure
,t1.curr_no
,t1.curr_name
;
commit;


/*==============第77组==============*/

--指标结果表03:自算-盈利类-1
insert into ${idl_schema}.tmp_mc_index_fact_jxkh_ind_result_3(
    index_no_mcs                                                 --指标编号_管驾
    ,index_name_mcs                                              --指标名称_管驾
    ,org_no                                                      --机构编号
    ,org_name                                                    --机构名称
    ,accu_index_value_m                                          --当月值
    -- 5
    ,accu_index_value_y                                          --当年值
    ,measure_no                                                  --度量编号
    ,index_measure                                               --度量名称
    ,curr_no                                                     --币种代码
    ,curr_name                                                   --币种名称
    -- 10
    ,etl_dt                                                      --ETL处理日期
    ,etl_timestamp                                               --ETL处理时间戳
)
select
    'JX020102086' as index_no_mcs                                --None
    ,'零售贷款收息率' as index_name_mcs                                 --None
    ,t1.org_no as org_no                                         --None
    ,'' as org_name                                              --None
    ,case
         when sum(t2.index_value) = 0 then
          0
         else
          sum(t1.accu_index_value_m) / (sum(t2.index_value) * max(to_char(add_months(trunc(t2.etl_dt, 'YEAR'), 12) - 1, 'DDD'))) / max(extract(day from t2.etl_dt))
       end as accu_index_value_m --None
    -- 5
    ,case
         when sum(t3.index_value) = 0 then
          0
         else
          sum(t1.accu_index_value_y) / (sum(t3.index_value) * max(to_char(add_months(trunc(t2.etl_dt, 'YEAR'), 12) - 1, 'DDD'))) / max(to_char(t2.etl_dt, 'DDD'))
       end as accu_index_value_y --None
    ,t1.MEASURE_NO as measure_no                                 --None
    ,t1.INDEX_MEASURE as index_measure                           --None
    ,t1.CURR_NO as curr_no                                       --None
    ,t1.CURR_NAME as curr_name                                   --None
    -- 10
    ,to_date('${batch_date}','yyyymmdd') as etl_dt               --None
    ,TO_TIMESTAMP('${batch_timestamp}','yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp --None
 from tmp_mc_index_fact_jxkh_ind_result_3 t1 --None 
INNER JOIN tmp_mc_index_fact_jxkh_ind_result_1 t2 --None 
 on t2.index_no_mcs in ('JX010102009','')
and t1.org_no=t2.org_no
and t2.measure_no='002'
and t1.curr_no=t2.curr_no
INNER JOIN tmp_mc_index_fact_jxkh_ind_result_1 t3 --None 
 on t3.index_no_mcs in ('JX010102009','')
and t1.org_no=t3.org_no
and t3.measure_no='004'
and t1.curr_no=t3.curr_no

where t1.index_no_mcs in ('JX020504156','')
GROUP BY t1.org_no
,t1.measure_no
,t1.index_measure
,t1.curr_no
,t1.curr_name
;
commit;


/*==============第78组==============*/

--指标结果表03:自算-盈利类-1
insert into ${idl_schema}.tmp_mc_index_fact_jxkh_ind_result_3(
    index_no_mcs                                                 --指标编号_管驾
    ,index_name_mcs                                              --指标名称_管驾
    ,org_no                                                      --机构编号
    ,org_name                                                    --机构名称
    ,accu_index_value_m                                          --当月值
    -- 5
    ,accu_index_value_y                                          --当年值
    ,measure_no                                                  --度量编号
    ,index_measure                                               --度量名称
    ,curr_no                                                     --币种代码
    ,curr_name                                                   --币种名称
    -- 10
    ,etl_dt                                                      --ETL处理日期
    ,etl_timestamp                                               --ETL处理时间戳
)
select
    'JX020102095' as index_no_mcs                                --None
    ,'零售存款付息率' as index_name_mcs                                 --None
    ,t1.org_no as org_no                                         --None
    ,'' as org_name                                              --None
    ,case
         when sum(t2.index_value) = 0 then
          0
         else
          sum(t1.accu_index_value_m) / (sum(t2.index_value) * max(to_char(add_months(trunc(t2.etl_dt, 'YEAR'), 12) - 1, 'DDD'))) / max(extract(day from t2.etl_dt))
       end as accu_index_value_m --None
    -- 5
    ,case
         when sum(t3.index_value) = 0 then
          0
         else
          sum(t1.accu_index_value_y) / (sum(t3.index_value) * max(to_char(add_months(trunc(t2.etl_dt, 'YEAR'), 12) - 1, 'DDD'))) / max(to_char(t2.etl_dt, 'DDD'))
       end as accu_index_value_y --None
    ,t1.MEASURE_NO as measure_no                                 --None
    ,t1.INDEX_MEASURE as index_measure                           --None
    ,t1.CURR_NO as curr_no                                       --None
    ,t1.CURR_NAME as curr_name                                   --None
    -- 10
    ,to_date('${batch_date}','yyyymmdd') as etl_dt               --None
    ,TO_TIMESTAMP('${batch_timestamp}','yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp --None
 from tmp_mc_index_fact_jxkh_ind_result_3 t1 --None 
INNER JOIN tmp_mc_index_fact_jxkh_ind_result_1 t2 --None 
 on t2.index_no_mcs in ('JX010201033','')
and t1.org_no=t2.org_no
and t2.measure_no='002'
and t1.curr_no=t2.curr_no
INNER JOIN tmp_mc_index_fact_jxkh_ind_result_1 t3 --None 
 on t3.index_no_mcs in ('JX010201033','')
and t1.org_no=t3.org_no
and t3.measure_no='004'
and t1.curr_no=t3.curr_no

where t1.index_no_mcs in ('JX020504150','')
GROUP BY t1.org_no
,t1.measure_no
,t1.index_measure
,t1.curr_no
,t1.curr_name
;
commit;


/*==============第79组==============*/

--指标结果表03:自算-盈利类-1
insert into ${idl_schema}.tmp_mc_index_fact_jxkh_ind_result_3(
    index_no_mcs                                                 --指标编号_管驾
    ,index_name_mcs                                              --指标名称_管驾
    ,org_no                                                      --机构编号
    ,org_name                                                    --机构名称
    ,accu_index_value_m                                          --当月值
    -- 5
    ,accu_index_value_y                                          --当年值
    ,measure_no                                                  --度量编号
    ,index_measure                                               --度量名称
    ,curr_no                                                     --币种代码
    ,curr_name                                                   --币种名称
    -- 10
    ,etl_dt                                                      --ETL处理日期
    ,etl_timestamp                                               --ETL处理时间戳
)
select
    'JX020101070' as index_no_mcs                                --None
    ,'存贷利差' as index_name_mcs                                    --None
    ,t1.org_no as org_no                                         --None
    ,'' as org_name                                              --None
    ,sum(nvl(t1.accu_index_value_m,0))-sum(nvl(t2.accu_index_value_m,0)) as accu_index_value_m --None
    -- 5
    ,sum(nvl(t1.accu_index_value_y,0))-sum(nvl(t2.accu_index_value_y,0)) as accu_index_value_y --None
    ,t1.MEASURE_NO as measure_no                                 --None
    ,t1.INDEX_MEASURE as index_measure                           --None
    ,t1.CURR_NO as curr_no                                       --None
    ,t1.CURR_NAME as curr_name                                   --None
    -- 10
    ,to_date('${batch_date}','yyyymmdd') as etl_dt               --None
    ,TO_TIMESTAMP('${batch_timestamp}','yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp --None
 from tmp_mc_index_fact_jxkh_ind_result_3 t1 --None 
INNER JOIN tmp_mc_index_fact_jxkh_ind_result_3 t2 --None 
 on t2.index_no_mcs='JX020102072'
and t1.org_no=t2.org_no
and t1.measure_no=t2.measure_no
and t1.curr_no=t2.curr_no

where t1.index_no_mcs='JX020102071'
GROUP BY t1.org_no
,t1.measure_no
,t1.index_measure
,t1.curr_no
,t1.curr_name
;
commit;


/*==============第80组==============*/

--指标结果表03:自算-盈利类-2
insert into ${idl_schema}.tmp_mc_index_fact_jxkh_ind_result_3(
    index_no_mcs                                                 --指标编号_管驾
    ,index_name_mcs                                              --指标名称_管驾
    ,org_no                                                      --机构编号
    ,org_name                                                    --机构名称
    ,accu_index_value_m                                          --当月值
    -- 5
    ,accu_index_value_y                                          --当年值
    ,measure_no                                                  --度量编号
    ,index_measure                                               --度量名称
    ,curr_no                                                     --币种代码
    ,curr_name                                                   --币种名称
    -- 10
    ,etl_dt                                                      --ETL处理日期
    ,etl_timestamp                                               --ETL处理时间戳
)
select
    'JX020101073' as index_no_mcs                                --None
    ,'对公存贷利差' as index_name_mcs                                  --None
    ,t1.org_no as org_no                                         --None
    ,'' as org_name                                              --None
    ,sum(nvl(t1.accu_index_value_m,0))-sum(nvl(t2.accu_index_value_m,0)) as accu_index_value_m --None
    -- 5
    ,sum(nvl(t1.accu_index_value_y,0))-sum(nvl(t2.accu_index_value_y,0)) as accu_index_value_y --None
    ,t1.MEASURE_NO as measure_no                                 --None
    ,t1.INDEX_MEASURE as index_measure                           --None
    ,t1.CURR_NO as curr_no                                       --None
    ,t1.CURR_NAME as curr_name                                   --None
    -- 10
    ,to_date('${batch_date}','yyyymmdd') as etl_dt               --None
    ,TO_TIMESTAMP('${batch_timestamp}','yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp --None
 from tmp_mc_index_fact_jxkh_ind_result_3 t1 --None 
INNER JOIN tmp_mc_index_fact_jxkh_ind_result_3 t2 --None 
 on t2.index_no_mcs='JX020102080'
and t1.org_no=t2.org_no
and t1.measure_no=t2.measure_no
and t1.curr_no=t2.curr_no

where t1.index_no_mcs='JX020102074'
GROUP BY t1.org_no
,t1.measure_no
,t1.index_measure
,t1.curr_no
,t1.curr_name
;
commit;


/*==============第81组==============*/

--指标结果表03:自算-盈利类-3
insert into ${idl_schema}.tmp_mc_index_fact_jxkh_ind_result_3(
    index_no_mcs                                                 --指标编号_管驾
    ,index_name_mcs                                              --指标名称_管驾
    ,org_no                                                      --机构编号
    ,org_name                                                    --机构名称
    ,accu_index_value_m                                          --当月值
    -- 5
    ,accu_index_value_y                                          --当年值
    ,measure_no                                                  --度量编号
    ,index_measure                                               --度量名称
    ,curr_no                                                     --币种代码
    ,curr_name                                                   --币种名称
    -- 10
    ,etl_dt                                                      --ETL处理日期
    ,etl_timestamp                                               --ETL处理时间戳
)
select
    'JX020101085' as index_no_mcs                                --None
    ,'零售存贷利差' as index_name_mcs                                  --None
    ,t1.org_no as org_no                                         --None
    ,'' as org_name                                              --None
    ,sum(nvl(t1.accu_index_value_m,0))-sum(nvl(t2.accu_index_value_m,0)) as accu_index_value_m --None
    -- 5
    ,sum(nvl(t1.accu_index_value_y,0))-sum(nvl(t2.accu_index_value_y,0)) as accu_index_value_y --None
    ,t1.MEASURE_NO as measure_no                                 --None
    ,t1.INDEX_MEASURE as index_measure                           --None
    ,t1.CURR_NO as curr_no                                       --None
    ,t1.CURR_NAME as curr_name                                   --None
    -- 10
    ,to_date('${batch_date}','yyyymmdd') as etl_dt               --None
    ,TO_TIMESTAMP('${batch_timestamp}','yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp --None
 from tmp_mc_index_fact_jxkh_ind_result_3 t1 --None 
INNER JOIN tmp_mc_index_fact_jxkh_ind_result_3 t2 --None 
 on t2.index_no_mcs='JX020102095'
and t1.org_no=t2.org_no
and t1.measure_no=t2.measure_no
and t1.curr_no=t2.curr_no

where t1.index_no_mcs='JX020102086'
GROUP BY t1.org_no
,t1.measure_no
,t1.index_measure
,t1.curr_no
,t1.curr_name
;
commit;


/*==============第82组==============*/

--指标结果表03:自算-盈利类-4
insert into ${idl_schema}.tmp_mc_index_fact_jxkh_ind_result_3(
    index_no_mcs                                                 --指标编号_管驾
    ,index_name_mcs                                              --指标名称_管驾
    ,org_no                                                      --机构编号
    ,org_name                                                    --机构名称
    ,accu_index_value_m                                          --当月值
    -- 5
    ,accu_index_value_y                                          --当年值
    ,measure_no                                                  --度量编号
    ,index_measure                                               --度量名称
    ,curr_no                                                     --币种代码
    ,curr_name                                                   --币种名称
    -- 10
    ,etl_dt                                                      --ETL处理日期
    ,etl_timestamp                                               --ETL处理时间戳
)
select
    'JX020402124' as index_no_mcs                                --None
    ,'投金业务减免税所得额' as index_name_mcs                              --None
    ,t1.org_no as org_no                                         --None
    ,'' as org_name                                              --None
    ,sum(nvl(t1.accu_index_value_m,0))-sum(nvl(t2.accu_index_value_m,0)) as accu_index_value_m --None
    -- 5
    ,sum(nvl(t1.accu_index_value_y,0))-sum(nvl(t2.accu_index_value_y,0)) as accu_index_value_y --None
    ,t1.MEASURE_NO as measure_no                                 --None
    ,t1.INDEX_MEASURE as index_measure                           --None
    ,t1.CURR_NO as curr_no                                       --None
    ,t1.CURR_NAME as curr_name                                   --None
    -- 10
    ,to_date('${batch_date}','yyyymmdd') as etl_dt               --None
    ,TO_TIMESTAMP('${batch_timestamp}','yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp --None
 from tmp_mc_index_fact_jxkh_ind_result_3 t1 --None 
INNER JOIN tmp_mc_index_fact_jxkh_ind_result_3 t2 --None 
 on t2.index_no_mcs='JX020402123'
and t2.org_no='896821'
and t1.measure_no=t2.measure_no
and t1.curr_no=t2.curr_no

where t1.index_no_mcs='JX020402123'
and t1.org_no='000000'
GROUP BY t1.org_no
,t1.measure_no
,t1.index_measure
,t1.curr_no
,t1.curr_name
;
commit;


/*==============第83组==============*/

--指标结果表03:自算-盈利类-5
insert into ${idl_schema}.tmp_mc_index_fact_jxkh_ind_result_3(
    index_no_mcs                                                 --指标编号_管驾
    ,index_name_mcs                                              --指标名称_管驾
    ,org_no                                                      --机构编号
    ,org_name                                                    --机构名称
    ,accu_index_value_m                                          --当月值
    -- 5
    ,accu_index_value_y                                          --当年值
    ,measure_no                                                  --度量编号
    ,index_measure                                               --度量名称
    ,curr_no                                                     --币种代码
    ,curr_name                                                   --币种名称
    -- 10
    ,etl_dt                                                      --ETL处理日期
    ,etl_timestamp                                               --ETL处理时间戳
)
select
    'JX020502183' as index_no_mcs                                --None
    ,'司库' as index_name_mcs                                      --None
    ,t1.org_no as org_no                                         --None
    ,'' as org_name                                              --None
    ,sum(case when t1.index_no_mcs<>'JX020501125' then 0-nvl(t1.accu_index_value_m,0) else nvl(t1.accu_index_value_m,0) end) as accu_index_value_m --None
    -- 5
    ,sum(case when t1.index_no_mcs<>'JX020501125' then 0-nvl(t1.accu_index_value_y,0) else nvl(t1.accu_index_value_y,0) end) as accu_index_value_y --None
    ,t1.MEASURE_NO as measure_no                                 --None
    ,t1.INDEX_MEASURE as index_measure                           --None
    ,t1.CURR_NO as curr_no                                       --None
    ,t1.CURR_NAME as curr_name                                   --None
    -- 10
    ,to_date('${batch_date}','yyyymmdd') as etl_dt               --None
    ,TO_TIMESTAMP('${batch_timestamp}','yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp --None
 from tmp_mc_index_fact_jxkh_ind_result_3 t1 --None 

where t1.index_no_mcs in ('JX020501125','JX020502126','JX020502147','JX020502165')
and t1.org_no='000000'
GROUP BY t1.org_no
,t1.measure_no
,t1.index_measure
,t1.curr_no
,t1.curr_name
;
commit;


/*==============第84组==============*/

--指标结果表03:自算-盈利类-5
insert into ${idl_schema}.tmp_mc_index_fact_jxkh_ind_result_3(
    index_no_mcs                                                 --指标编号_管驾
    ,index_name_mcs                                              --指标名称_管驾
    ,org_no                                                      --机构编号
    ,org_name                                                    --机构名称
    ,accu_index_value_m                                          --当月值
    -- 5
    ,accu_index_value_y                                          --当年值
    ,measure_no                                                  --度量编号
    ,index_measure                                               --度量名称
    ,curr_no                                                     --币种代码
    ,curr_name                                                   --币种名称
    -- 10
    ,etl_dt                                                      --ETL处理日期
    ,etl_timestamp                                               --ETL处理时间戳
)
select
    'JX020401122' as index_no_mcs                                --None
    ,'同业业务减免所得额' as index_name_mcs                               --None
    ,'000000' as org_no                                          --None
    ,'' as org_name                                              --None
    ,sum(nvl(t1.accu_index_value_m,0)) as accu_index_value_m     --None
    -- 5
    ,sum(nvl(t1.accu_index_value_y,0)) as accu_index_value_y     --None
    ,t1.MEASURE_NO as measure_no                                 --None
    ,t1.INDEX_MEASURE as index_measure                           --None
    ,t1.CURR_NO as curr_no                                       --None
    ,t1.CURR_NAME as curr_name                                   --None
    -- 10
    ,to_date('${batch_date}','yyyymmdd') as etl_dt               --None
    ,TO_TIMESTAMP('${batch_timestamp}','yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp --None
 from tmp_mc_index_fact_jxkh_ind_result_3 t1 --None 

where t1.index_no_mcs in ('JX020402123','JX020402124')
and (case when t1.index_no_mcs='JX020402123' then '896821' 
         when t1.index_no_mcs='JX020402124' then '000000'
end)=t1.org_no 
GROUP BY t1.measure_no
,t1.index_measure
,t1.curr_no
,t1.curr_name
;
commit;


/*==============第85组==============*/

--指标结果表03:组合计算-其他负债付息率
insert into ${idl_schema}.tmp_mc_index_fact_jxkh_ind_result_3(
    index_no_mcs                                                 --指标编号_管驾
    ,index_name_mcs                                              --指标名称_管驾
    ,org_no                                                      --机构编号
    ,org_name                                                    --机构名称
    ,accu_index_value_m                                          --当月值
    -- 5
    ,accu_index_value_y                                          --当年值
    ,measure_no                                                  --度量编号
    ,index_measure                                               --度量名称
    ,curr_no                                                     --币种代码
    ,curr_name                                                   --币种名称
    -- 10
    ,etl_dt                                                      --ETL处理日期
    ,etl_timestamp                                               --ETL处理时间戳
)
select
    'JX020302111' as index_no_mcs                                --None
    ,'其他负债付息率' as index_name_mcs                                 --None
    ,t2.org_no as org_no                                         --None
    ,t3.org_abbr as org_name                                     --None
    ,case when sum(t6.index_value)=0 then 0 else sum(case when t2.index_no_mcs<>'JX0102010381' then 0-nvl(t2.accu_index_value_m,0) else nvl(t2.accu_index_value_m,0) end)/sum(t6.index_value)* max(to_char(add_months(trunc(t2.etl_dt, 'YEAR'), 12) - 1, 'DDD')) / max(extract(day from t2.etl_dt)) end as accu_index_value_m --None
    -- 5
    ,case when sum(t7.index_value)=0 then 0 else sum(case when t2.index_no_mcs<>'JX0102010381' then 0-nvl(t2.accu_index_value_m,0) else nvl(t2.accu_index_value_m,0) end)/sum(t7.index_value)* max(to_char(add_months(trunc(t2.etl_dt, 'YEAR'), 12) - 1, 'DDD')) / max(to_char(t2.etl_dt, 'DDD')) end as accu_index_value_y --None
    ,'001' as measure_no                                         --None
    ,'当期值' as index_measure                                      --None
    ,t2.CURR_NO as curr_no                                       --None
    ,t2.CURR_NAME as curr_name                                   --None
    -- 10
    ,to_date('${batch_date}','yyyymmdd') as etl_dt               --None
    ,TO_TIMESTAMP('${batch_timestamp}','yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp --None
 from tmp_mc_index_fact_jxkh_ind_result_3 t2 --None 
INNER JOIN mtl_fml_f99_int_org_info_new t3 --None 
 on t2.org_no = t3.org_id
   and t3.etl_dt = to_date('${batch_date}','yyyymmdd')
LEFT JOIN tmp_mc_index_fact_jxkh_ind_result_1 t6 --None 
 on t6.index_no_mcs='JX010202041'
and t6.org_no=t2.org_no
and t6.curr_no=t2.curr_no
and t6.MEASURE_NO='002'
LEFT JOIN tmp_mc_index_fact_jxkh_ind_result_1 t7 --None 
 on t7.index_no_mcs='JX010202041'
and t7.org_no=t2.org_no
and t7.curr_no=t2.curr_no
and t7.MEASURE_NO='004'

where t2.index_no_mcs in ('JX0102010381','JX0102020391','JX0102020401')
GROUP BY t2.org_no
,t3.org_abbr
,t2.curr_no
,t2.CURR_NAME;
commit;


/*==============第86组==============*/

--插入目标表:插入目标表-规模类、客户及其他
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
    to_date('${batch_date}','yyyymmdd') as etl_dt                --None
    ,t1.INDEX_NO_MCS as index_no                                 --None
    ,t1.INDEX_NAME_MCS as index_name                             --None
    ,t1.org_no as org_no                                         --None
    ,t2.ORG_ABBR as org_name                                     --None
    -- 5
    ,t2.BRCH_ID as super_org_no                                  --None
    ,'' as org_sort                                              --None
    ,t1.CURR_NO as curr_no                                       --None
    ,t1.CURR_NAME as curr_name                                   --None
    ,t1.INDEX_VALUE as index_value                               --None
    -- 10
    ,0 as accu_index_value_m                                     --None
    ,0 as accu_index_value_y                                     --None
    ,coalesce(t1.INDEX_VALUE,0) - coalesce(t4.INDEX_VALUE,0) as rate_up_day --None
    ,coalesce(t1.INDEX_VALUE,0) - coalesce(t5.INDEX_VALUE,0) as rate_last_month --None
    ,coalesce(t1.INDEX_VALUE,0) - coalesce(t7.INDEX_VALUE,0) as rate_last_year --None
    -- 15
    ,coalesce(t1.INDEX_VALUE,0) - coalesce(t8.INDEX_VALUE,0) as rate_last_period --None
    ,case when coalesce(t4.INDEX_VALUE ,0) =0 then 0 
               else  round((coalesce(t1.INDEX_VALUE,0) - coalesce(t4.INDEX_VALUE,0)) / coalesce(t4.INDEX_VALUE,0),6) 
               end as rate_up_day_per --None
    ,case when coalesce(t5.INDEX_VALUE ,0) =0 then 0 
               else  round((coalesce(t1.INDEX_VALUE,0) - coalesce(t5.INDEX_VALUE,0)) / coalesce(t5.INDEX_VALUE,0),6) 
               end as rate_last_month_per --None
    ,case when coalesce(t7.INDEX_VALUE ,0) =0 then 0 
               else  round((coalesce(t1.INDEX_VALUE,0) - coalesce(t7.INDEX_VALUE,0)) / coalesce(t7.INDEX_VALUE,0),6) 
               end as rate_last_year_per --None
    ,case when coalesce(t8.INDEX_VALUE ,0) =0 then 0 
               else  round((coalesce(t1.INDEX_VALUE,0) - coalesce(t8.INDEX_VALUE,0)) / coalesce(t8.INDEX_VALUE,0),6) 
               end as rate_last_period_per --None
    -- 20
    ,0 as index_ranking                                          --None
    ,0 as index_ranking_cha                                      --None
    ,0 as index_value_avg                                        --None
    ,0 as index_value_limit                                      --None
    ,0 as ratio_index                                            --None
    -- 25
    ,0 as ratio_org                                              --None
    ,t3.unit as unit                                             --None
    ,'' as frequency                                             --None
    ,t1.MEASURE_NO as measure_no                                 --None
    ,'JXKH' as source_sys                                        --None
    -- 30
    ,t1.INDEX_MEASURE as index_measure                           --None
    ,TO_TIMESTAMP('${batch_timestamp}','yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp --None
    ,coalesce(t1.INDEX_VALUE,0) - coalesce(t6.INDEX_VALUE,0) as rate_last_quater --None
    ,case when coalesce(t6.INDEX_VALUE ,0) =0 then 0 
               else  round((coalesce(t1.INDEX_VALUE,0) - coalesce(t6.INDEX_VALUE,0)) / coalesce(t6.INDEX_VALUE,0),6) 
               end as rate_last_quater_per --None
    ,'' as supervision_require                                   --None
    -- 35
    ,'' as limit_value                                           --None
    ,'' as prewarning_value                                      --None
    ,'' as intrv_type                                            --None
    ,0 as rate_last_week                                         --None
 from tmp_mc_index_fact_jxkh_ind_result_1 t1 --None 
LEFT JOIN mtl_cmm_intnal_org_info t2 --None 
 on t2.etl_dt=to_date('${batch_date}','yyyymmdd')
and t2.ORG_ID=t1.org_no
LEFT JOIN mc_index_define t3 --None 
 on t3.index_no_mcs=t1.INDEX_NO_MCS
LEFT JOIN mc_index_fact t4 --None 
 on t4.etl_dt=to_date('${last_date}','yyyymmdd')
and t4.curr_no=t1.curr_no
and t4.index_no=t1.INDEX_NO_MCS
and t4.org_no=t1.ORG_NO
and t4.MEASURE_NO=t1.MEASURE_NO
LEFT JOIN mc_index_fact t5 --None 
 on t5.etl_dt=to_date('${last_month_end}','yyyymmdd')
and t5.curr_no=t1.curr_no
and t5.index_no=t1.INDEX_NO_MCS
and t5.org_no=t1.ORG_NO
and t5.MEASURE_NO=t1.MEASURE_NO
LEFT JOIN mc_index_fact t6 --None 
 on t6.etl_dt=to_date('${last_quarter_end}','yyyymmdd')
and t6.curr_no=t1.curr_no
and t6.index_no=t1.INDEX_NO_MCS
and t6.org_no=t1.ORG_NO
and t6.MEASURE_NO=t1.MEASURE_NO
LEFT JOIN mc_index_fact t7 --None 
 on t7.etl_dt=to_date('${last_year_end}','yyyymmdd')
and t7.curr_no=t1.curr_no
and t7.index_no=t1.INDEX_NO_MCS
and t7.org_no=t1.ORG_NO
and t7.MEASURE_NO=t1.MEASURE_NO
LEFT JOIN mc_index_fact t8 --None 
 on t8.etl_dt=to_date('${last_year_bath_date}','yyyymmdd')
and t8.curr_no=t1.curr_no
and t8.index_no=t1.INDEX_NO_MCS
and t8.org_no=t1.ORG_NO
and t8.MEASURE_NO=t1.MEASURE_NO

 
 
;
commit;


/*==============第87组==============*/

--插入目标表:插入目标表-盈利类
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
    to_date('${batch_date}','yyyymmdd') as etl_dt                --None
    ,t1.INDEX_NO_MCS as index_no                                 --None
    ,t1.INDEX_NAME_MCS as index_name                             --None
    ,t1.org_no as org_no                                         --None
    ,t2.ORG_ABBR as org_name                                     --None
    -- 5
    ,t2.BRCH_ID as super_org_no                                  --None
    ,'' as org_sort                                              --None
    ,t1.CURR_NO as curr_no                                       --None
    ,t1.CURR_NAME as curr_name                                   --None
    ,0 as index_value                                            --None
    -- 10
    ,t1.accu_index_value_m as accu_index_value_m                 --None
    ,t1.accu_index_value_y as accu_index_value_y                 --None
    ,0 as rate_up_day                                            --None
    ,coalesce(t1.accu_index_value_m,0) - coalesce(t5.accu_index_value_m,0) as rate_last_month --None
    ,coalesce(t1.accu_index_value_y,0) - coalesce(t7.accu_index_value_y,0) as rate_last_year --None
    -- 15
    ,coalesce(t1.accu_index_value_y,0) - coalesce(t8.accu_index_value_y,0) as rate_last_period --None
    ,0 as rate_up_day_per                                        --None
    ,case when coalesce(t5.accu_index_value_m ,0) =0 then 0 
               else  round((coalesce(t1.accu_index_value_m,0) - coalesce(t5.accu_index_value_m,0)) / coalesce(t5.accu_index_value_m,0),6) 
               end as rate_last_month_per --None
    ,case when coalesce(t7.accu_index_value_y ,0) =0 then 0 
               else  round((coalesce(t1.accu_index_value_y,0) - coalesce(t7.accu_index_value_y,0)) / coalesce(t7.accu_index_value_y,0),6) 
               end as rate_last_year_per --None
    ,case when coalesce(t8.accu_index_value_y ,0) =0 then 0 
               else  round((coalesce(t1.accu_index_value_y,0) - coalesce(t8.accu_index_value_y,0)) / coalesce(t8.accu_index_value_y,0),6) 
               end as rate_last_period_per --None
    -- 20
    ,0 as index_ranking                                          --None
    ,0 as index_ranking_cha                                      --None
    ,0 as index_value_avg                                        --None
    ,0 as index_value_limit                                      --None
    ,0 as ratio_index                                            --None
    -- 25
    ,0 as ratio_org                                              --None
    ,t3.unit as unit                                             --None
    ,'' as frequency                                             --None
    ,t1.MEASURE_NO as measure_no                                 --None
    ,'JXKH' as source_sys                                        --None
    -- 30
    ,t1.INDEX_MEASURE as index_measure                           --None
    ,TO_TIMESTAMP('${batch_timestamp}','yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp --None
    ,0 as rate_last_quater                                       --None
    ,0 as rate_last_quater_per                                   --None
    ,'' as supervision_require                                   --None
    -- 35
    ,'' as limit_value                                           --None
    ,'' as prewarning_value                                      --None
    ,'' as intrv_type                                            --None
    ,0 as rate_last_week                                         --None
 from tmp_mc_index_fact_jxkh_ind_result_3 t1 --None 
LEFT JOIN mtl_cmm_intnal_org_info t2 --None 
 on t2.etl_dt=to_date('${batch_date}','yyyymmdd')
and t2.ORG_ID=t1.org_no
LEFT JOIN mc_index_define t3 --None 
 on t3.index_no_mcs=t1.INDEX_NO_MCS
LEFT JOIN mc_index_fact t4 --None 
 on t4.etl_dt=to_date('${last_date}','yyyymmdd')
and t4.curr_no=t1.curr_no
and t4.index_no=t1.INDEX_NO_MCS
and t4.org_no=t1.ORG_NO
and t4.MEASURE_NO=t1.MEASURE_NO
LEFT JOIN mc_index_fact t5 --None 
 on t5.etl_dt=to_date('${last_month_end}','yyyymmdd')
and t5.curr_no=t1.curr_no
and t5.index_no=t1.INDEX_NO_MCS
and t5.org_no=t1.ORG_NO
and t5.MEASURE_NO=t1.MEASURE_NO
LEFT JOIN mc_index_fact t6 --None 
 on t6.etl_dt=to_date('${last_quarter_end}','yyyymmdd')
and t6.curr_no=t1.curr_no
and t6.index_no=t1.INDEX_NO_MCS
and t6.org_no=t1.ORG_NO
and t6.MEASURE_NO=t1.MEASURE_NO
LEFT JOIN mc_index_fact t7 --None 
 on t7.etl_dt=to_date('${last_year_end}','yyyymmdd')
and t7.curr_no=t1.curr_no
and t7.index_no=t1.INDEX_NO_MCS
and t7.org_no=t1.ORG_NO
and t7.MEASURE_NO=t1.MEASURE_NO
LEFT JOIN mc_index_fact t8 --None 
 on t8.etl_dt=to_date('${last_year_bath_date}','yyyymmdd')
and t8.curr_no=t1.curr_no
and t8.index_no=t1.INDEX_NO_MCS
and t8.org_no=t1.ORG_NO
and t8.MEASURE_NO=t1.MEASURE_NO

 
 
;
commit;

--delete tmp table
whenever sqlerror continue none;
drop table ${idl_schema}.tmp_mc_index_fact_jxkh_ind_result_2 purge;
drop table ${idl_schema}.tmp_mc_index_fact_jxkh_ind_result_1 purge;
drop table ${idl_schema}.tmp_mc_index_fact_jxkh_ind_result_3 purge;

-- 3.1 gather table status
exec dbms_stats.gather_table_stats(ownname => '${idl_schema}', tabname => 'mc_index_fact', partname => 'p_${batch_date}_JXKH', granularity => 'SUBPARTITION', degree => 8, cAScade => true);
