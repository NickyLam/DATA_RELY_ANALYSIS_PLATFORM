/*
Purpose:    STM重空明细D层-重空明细事实表(WD040805):数据来源于核心+自助设备
Author:     Sunline/郑沛隆
Usage:      python $ETL_HOME/script/main.py yyyymmdd idl_mcyy_blank_vouch_dtl
Createdate: 20210603
Logs:

-- 生成的IDL层表 mcyy_blank_vouch_dtl
-- 以下为依赖了上游的表 :
-- itl_edw_cmm_teller_info
-- itl_edw_cbss_knd_draw
-- itl_edw_cbss_iab_atmu
-- itl_edw_atms_retain_card_table 
-- 以下为依赖的参数表 :
-- mcyy_index_define  -- 指标表清单
-- mcyy_orga_para     -- 总分支机构表

*/

set timing on

-- 1 alter parallel
alter session force parallel query parallel 4;
alter session force parallel dml parallel 4;
-- alter session force parallel ddl parallel 8;


-- 2.1 drop timeout partition 
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none;

alter table ${idl_schema}.mcyy_blank_vouch_dtl truncate subpartition p_${batch_date}_card_dtl;


-- 2.2 add today partition
whenever sqlerror continue none;

alter table ${idl_schema}.mcyy_blank_vouch_dtl add partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'))(
                                              subpartition p_${batch_date}_card_dtl values ('CARD_DTL')
                                              )
;
alter table ${idl_schema}.mcyy_blank_vouch_dtl modify partition p_${batch_date} 
                                             add subpartition p_${batch_date}_card_dtl values ('CARD_DTL')
;

-- 2.3 insert data target table

--第一组：分行合计
whenever sqlerror exit sql.sqlcode;

INSERT /*+ append */
INTO ${idl_schema}.mcyy_blank_vouch_dtl
    (etl_dt
    , -- ETL日期  
     index_no
    , -- 指标编号 
     index_name
    , -- 指标名称 
     org_no
    , -- 机构编号 
     org_name
    , -- 机构名称 
     super_org_no
    , -- 上级机构代码 
     blank_num
    , -- 重空数量 
     dev_no
    , -- 设备编号 
     card_no
    , -- 卡号     
     reason
    , -- 原因     
     take_org
    , -- 处理机构 
     rgstrat
    , -- 登记人   
     rgst_time
    , -- 登记时间 
     proc_ps
    , -- 处理人   
     proc_time
    , -- 处理时间 
     proc_site
    , -- 处理地点 
     cust_name
    , -- 客户姓名 
     card_status
    , -- 吞卡状态 
     etl_timestamp
    ,source_sys
    ,card_nums
    ,shield_nums)
    WITH tmp_td_initza AS
    --当日数据初始化
     (SELECT t6.index_no
            , --指标编码
             t6.index_name_mcs AS index_name
            , --指标名称
             t5.org_no         AS org_no
            , --机构编码
             t5.org_name       AS org_name
            , --机构名称
             t5.super_org_no   AS super_org_no
             --上级机构编码
            ,nvl(t4.dcmtnm
                ,0) AS blank_num -- 重空数量 
            ,t1.devicenum AS dev_no -- 设备编号 
            ,t2.account AS card_no -- 卡号     
            ,t2.reason AS reason -- 原因    
            ,t2.card_handle_org AS take_org -- 处理机构 
            ,t2.check_op AS rgstrat -- 登记人 
            ,t2.check_date || ' ' || t2.check_time AS rgst_time -- 登记时间 
            ,t2.op_no AS proc_ps -- 处理人
            ,t2.op_date || ' ' || t2.op_time AS proc_time -- 处理时间 
            ,t2.op_address AS proc_site -- 处理地点 
            ,t2.account_name AS cust_name -- 客户姓名
             --0-留机，自动吞卡独有；1-登记； 20-领取；21-销毁 
            ,(CASE
                 WHEN t2.status = '0' THEN
                  '留机'
                 WHEN t2.status = '1' THEN
                  '登记'
                 WHEN t2.status = '20' THEN
                  '领取'
                 WHEN t2.status = '21' THEN
                  '销毁'
                 ELSE
                  NULL
             END) AS card_status -- 吞卡状态 
            ,nvl(t4.dcmtnm
                ,0) - t4.shield_nums AS card_nums
            ,t4.shield_nums AS shield_nums
      FROM   msl_nibs_ib_dev_device_info t1
      LEFT   JOIN itl_edw_atms_retain_card_table t2
      ON     t1.devicenum = t2.dev_no
      AND    to_date(t2.retain_date
                    ,'yyyy-mm-dd') =
             to_date('${batch_date}'
                     ,'yyyymmdd')
      LEFT   JOIN (SELECT SUM(d.VOUCHER_SUM) AS dcmtnm,
       a.DEVICENUM as atmcod,
       SUM(CASE
             WHEN d.DOC_TYPE IN ('801', '802') --USBKEY即盾
              THEN
              d.VOUCHER_SUM
             ELSE
              0
           END) AS shield_nums
  FROM msl_nibs_IB_DEV_DEVICE_INFO a
  LEFT JOIN itl_edw_ncbs_tb_tailbox c --尾箱关联
    ON a.VIRTUALUSERNUM = c.USER_ID
  LEFT JOIN itl_edw_ncbs_TB_VOUCHER_INFO D --凭证关联
    ON D.tailbox_id = C.tailbox_id
 where a.DEVICETYPENUM='06'
 group by a.DEVICENUM
) t4 --核心重空
      ON     t4.atmcod = t1.devicenum
      INNER   JOIN mcyy_orga_para t5
      ON     t5.org_no = t1.ASCRBRANCH
      INNER  JOIN mcyy_index_define t6
      ON     'WD040805' = t6.index_no_mcs
      WHERE  t1.devicetypenum = '06' --STM机器
      AND    t1.operstatus != '3'
      AND    t1.devicesatus <> '0')
    SELECT to_date('${batch_date}'
                  ,'yyyymmdd') etl_dt -- 数据日期          
          ,index_no
          , -- 指标编号 
           index_name
          , -- 指标名称 
           org_no
          , -- 机构编号 
           org_name
          , -- 机构名称 
           super_org_no
          , -- 上级机构代码 
           blank_num
          , -- 重空数量 
           dev_no
          , -- 设备编号 
           card_no
          , -- 卡号     
           reason
          , -- 原因     
           take_org
          , -- 处理机构 
           rgstrat
          , -- 登记人   
           rgst_time
          , -- 登记时间 
           proc_ps
          , -- 处理人   
           proc_time
          , -- 处理时间 
           proc_site
          , -- 处理地点 
           cust_name
          , -- 客户姓名 
           card_status
          , -- 吞卡状态 
           to_timestamp('${batch_timestamp}'
                       ,'yyyy-mm-dd hh24:mi:ss.ff6') etl_timestamp -- ETL处理时间戳
          ,'CARD_DTL' source_sys --来源系统
          ,card_nums
          ,shield_nums
    FROM   tmp_td_initza;

COMMIT;

-- 3 table grant
whenever sqlerror exit sql.sqlcode;
grant select on ${idl_schema}.mcyy_blank_vouch_dtl to ${idl_schema};

-- 4 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${idl_schema}',tabname => 'mcyy_blank_vouch_dtl',partname => 'p_${batch_date}', granularity => 'PARTITION', degree => 8, cascade => true);