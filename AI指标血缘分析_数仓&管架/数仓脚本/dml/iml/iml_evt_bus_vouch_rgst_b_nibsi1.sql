/*
Purpose:    整全模型层-增量流水脚本，清空目标表当天分区数据，把当天数据与目标表进行分区交换。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iml_evt_bus_vouch_rgst_b_nibsi1
CreateDate: 20180515
Logs:
    zjj 2018-05-15 新建表本
*/

set timing on

-- 1 alter parallel
alter session force parallel query parallel 4;
alter session force parallel dml parallel 4;
-- alter session force parallel ddl parallel 1;

-- 2.1 create table for exchage and add partition
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iml_schema}.evt_bus_vouch_rgst_b_nibsi1_tm purge;
alter table ${iml_schema}.evt_bus_vouch_rgst_b add partition p_nibsi1 values ('nibsi1')(
        subpartition p_nibsi1_${batch_date} values (to_date('${batch_date}','yyyymmdd'))
    )
;
alter table ${iml_schema}.evt_bus_vouch_rgst_b modify partition p_nibsi1
    add subpartition p_nibsi1_${batch_date} values (to_date('${batch_date}','yyyymmdd'))
;

whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.evt_bus_vouch_rgst_b_nibsi1_tm
compress ${option_switch} for query high
as
select
    evt_id -- 事件编号
    ,lp_id -- 法人编号
    ,rgst_flow_num -- 登记流水号
    ,rgst_dt -- 登记日期
    ,rgst_batch_no -- 登记批次号
    ,bus_flow_num -- 业务流水号
    ,chn_dt -- 渠道日期
    ,chn_flow_num -- 渠道流水号
    ,chn_cd -- 渠道代码
    ,vouch_seq_num -- 凭证序号
    ,vouch_type_cd -- 凭证类型代码
    ,trdpty_tran_code -- 第三方交易码
    ,proc_step_cd -- 处理步骤代码
    ,proc_status_cd -- 处理状态代码
    ,proc_cnt -- 处理次数
    ,proc_dt -- 处理日期
    ,app_process_cd -- 应用处理码
    ,app_proc_info -- 应用处理信息
    ,blip_batch_no -- 影像批次号
    ,file_num_create_way_cd -- 归档号生成方式代码
    ,doc_upload_status_cd -- 文件上传状态代码
    ,org_id -- 机构编号
    ,teller_id -- 柜员编号
    ,init_create_dt -- 最初创建日期
    ,modif_dt -- 修改日期
    ,remark -- 备注
    ,remark_2 -- 备注2
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
from ${iml_schema}.evt_bus_vouch_rgst_b
where 0=1;


-- it is no need to check when this segment SQL was return faied
whenever sqlerror exit sql.sqlcode;
-- 3.1 insert data to tm table
-- nibs_pl_vou_businotice_log-1
insert into ${iml_schema}.evt_bus_vouch_rgst_b_nibsi1_tm(
    evt_id -- 事件编号
    ,lp_id -- 法人编号
    ,rgst_flow_num -- 登记流水号
    ,rgst_dt -- 登记日期
    ,rgst_batch_no -- 登记批次号
    ,bus_flow_num -- 业务流水号
    ,chn_dt -- 渠道日期
    ,chn_flow_num -- 渠道流水号
    ,chn_cd -- 渠道代码
    ,vouch_seq_num -- 凭证序号
    ,vouch_type_cd -- 凭证类型代码
    ,trdpty_tran_code -- 第三方交易码
    ,proc_step_cd -- 处理步骤代码
    ,proc_status_cd -- 处理状态代码
    ,proc_cnt -- 处理次数
    ,proc_dt -- 处理日期
    ,app_process_cd -- 应用处理码
    ,app_proc_info -- 应用处理信息
    ,blip_batch_no -- 影像批次号
    ,file_num_create_way_cd -- 归档号生成方式代码
    ,doc_upload_status_cd -- 文件上传状态代码
    ,org_id -- 机构编号
    ,teller_id -- 柜员编号
    ,init_create_dt -- 最初创建日期
    ,modif_dt -- 修改日期
    ,remark -- 备注
    ,remark_2 -- 备注2
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
)
select
    '401033'||P1.NOTICESERNO||P1.NOTICEDATE -- 事件编号
    ,'9999' -- 法人编号
    ,P1.NOTICESERNO -- 登记流水号
    ,P1.NOTICEDATE -- 登记日期
    ,P1.NOTICEBATCHNO -- 登记批次号
    ,P1.PRINTNO -- 业务流水号
    ,P1.CHANNELDATE -- 渠道日期
    ,P1.CHANNELSERNO -- 渠道流水号
    ,CASE WHEN R1.TARGET_CD_VAL IS NOT NULL THEN R1.TARGET_CD_VAL ELSE '@'||P1.CHANNELCODE END -- 渠道代码
    ,P1.VOUTYPE -- 凭证序号
    ,nvl(trim(P1.VOUKIND),'-') -- 凭证类型代码
    ,P1.SCENECODE -- 第三方交易码
    ,nvl(trim(P1.NOTICESTEP),'-') -- 处理步骤代码
    ,nvl(trim(P1.NOTICESTATUS),'-') -- 处理状态代码
    ,to_number(nvl(trim(P1.PROCNUM),0)) -- 处理次数
    ,P1.OPRDATE -- 处理日期
    ,P1.DEALCODE -- 应用处理码
    ,P1.DEALMSG -- 应用处理信息
    ,P1.AIMCONTENTID -- 影像批次号
    ,nvl(trim(P1.GENIDFLAG),'-') -- 归档号生成方式代码
    ,nvl(trim(P1.FILEUPSTATUS),'-') -- 文件上传状态代码
    ,P1.ORGID -- 机构编号
    ,P1.TELLERID -- 柜员编号
    ,P1.CRTDATETIME -- 最初创建日期
    ,P1.ALTDATETIME -- 修改日期
    ,P1.REMARK -- 备注
    ,P1.REMARK2 -- 备注2
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,'nibs_pl_vou_businotice_log' -- 源表名称
    ,'nibsi1' -- 任务编码
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间戳
from ${iol_schema}.nibs_pl_vou_businotice_log p1
    left join ${iml_schema}.ref_pub_cd_map r1 on P1.CHANNELCODE= R1.SRC_CODE_VAL
        AND R1.SORC_SYS_CD= 'NIBS'
        AND R1.SRC_TAB_EN_NAME= 'NIBS_PL_VOU_BUSINOTICE_LOG'
        AND R1.SRC_FIELD_EN_NAME= 'CHANNELCODE'
        AND R1.TARGET_TAB_EN_NAME= 'EVT_BUS_VOUCH_RGST_B'
        AND R1.TARGET_TAB_FIELD_EN_NAME= 'CHN_CD'
where  1 = 1 
    and p1.etl_dt = to_date('${batch_date}','yyyymmdd')
;
commit;



-- 3.2 truncate target table batch_date partition
alter table ${iml_schema}.evt_bus_vouch_rgst_b truncate subpartition p_nibsi1_${batch_date} reuse storage;


-- 3.3 exchage tm table and target table
alter table ${iml_schema}.evt_bus_vouch_rgst_b exchange subpartition p_nibsi1_${batch_date} with table ${iml_schema}.evt_bus_vouch_rgst_b_nibsi1_tm;

-- 4.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iml_schema}.evt_bus_vouch_rgst_b to ${iml_schema};

-- 4.2 drop tm table
drop table ${iml_schema}.evt_bus_vouch_rgst_b_nibsi1_tm purge;

-- 5 gater table status
exec dbms_stats.gather_table_stats(ownname => '${iml_schema}',tabname => 'evt_bus_vouch_rgst_b', partname => 'p_nibsi1_${batch_date}', ESTIMATE_PERCENT=>10, method_opt=>'for all columns size 1',no_invalidate=>false, force=>true, granularity => 'SUBPARTITION', degree => 8, cascade => true);