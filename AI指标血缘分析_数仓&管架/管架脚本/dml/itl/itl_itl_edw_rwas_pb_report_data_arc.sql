/*
Purpose:    技术缓冲层脚本，把数据文件加载到目标表的当天分区中。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd itl_itl_edw_rwas_pb_report_data_arc
CreateDate: 20180515
Logs:
    luzd 2019-05-27 新建脚本
*/

set timing on

-- 1 alter parallel
alter session force parallel query parallel 8;
alter session force parallel dml parallel 8;
-- alter session force parallel ddl parallel 8;


-- 2.1 drop timeout partition and add partition
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none;
--alter table ${itl_schema}.itl_edw_rwas_pb_report_data_arc drop partition p_${retain_day};
alter table ${itl_schema}.itl_edw_rwas_pb_report_data_arc drop partition p_${batch_date};

-- 2.2 add today partition
whenever sqlerror exit sql.sqlcode;
alter table ${itl_schema}.itl_edw_rwas_pb_report_data_arc add  partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

-- 2.3 insert data target table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ into ${itl_schema}.itl_edw_rwas_pb_report_data_arc partition for (to_date('${batch_date}','yyyymmdd')) (
    data_id -- 主键id
    ,item_cd -- 报表编码
    ,item_name -- 报表名称
    ,line_number -- 行号
    ,item_a -- a列
    ,item_b -- b列
    ,item_c -- c列
    ,item_d -- d列
    ,item_e -- e列
    ,item_f -- f列
    ,item_g -- g列
    ,item_h -- h列
    ,item_i -- i列
    ,item_j -- j列
    ,item_k -- k列
    ,item_l -- l列
    ,item_m -- m列
    ,item_n -- n列
    ,item_o -- o列
    ,item_p -- p列
    ,item_q -- q列
    ,item_r -- r列
    ,item_s -- s列
    ,item_t -- t列
    ,item_u -- u列
    ,item_v -- v列
    ,item_w -- w列
    ,item_x -- x列
    ,item_y -- y列
    ,item_z -- z列
    ,item_aa -- aa列
    ,item_ab -- ab列
    ,item_ac -- ac列
    ,item_ad -- ad列
    ,item_ae -- ae列
    ,item_af -- af列
    ,load_date -- 加载时间
    ,data_date -- 数据日期(格式yyyymmdd)
    ,solo_no -- 法人机构编号
    ,item_ag -- ag列
    ,item_ah -- ah列
    ,item_ai -- ai列
    ,item_aj -- aj列
    ,item_ak -- ak列
    ,item_al -- al列
    ,item_am -- am列
    ,item_an -- an列
    ,item_ao -- ao列
    ,item_ap -- ap列
    ,item_aq -- aq列
    ,item_ar -- ar列
    ,item_as -- as列
    ,item_at -- at列
    ,item_au -- au列
    ,item_av -- av列
    ,item_aw -- aw列
    ,item_ax -- ax列
    ,item_ay -- ay列
    ,item_az -- az列
    ,item_ba -- ba列
    ,item_bb -- bb列
    ,item_bc -- bc列
    ,item_bd -- bd列
    ,item_be -- be列
    ,item_bf -- bf列
    ,item_bg -- bg列
    ,item_bh -- bh列
    ,item_bi -- bi列
    ,item_bj -- bj列
    ,item_bk -- bk列
    ,item_bl -- bl列
    ,item_bm -- bm列
    ,item_bn -- bn列
    ,item_bo -- bo列
    ,item_bp -- bp列
    ,item_bq -- bq列
    ,item_br -- br列
    ,item_bs -- bs列
    ,item_bt -- bt列
    ,item_bu -- bu列
    ,item_bv -- bv列
    ,item_bw -- bw列
    ,item_bx -- bx列
    ,item_by -- by列
    ,item_bz -- bz列
    ,item_ca -- ca列
    ,item_cb -- cb列
    ,item_cc -- cc列
    ,item_ccd -- cd列
    ,item_ce -- ce列
    ,item_cf -- cf列
    ,item_cg -- cg列
    ,item_ch -- ch列
    ,item_ci -- ci列
    ,item_cj -- cj列
    ,item_ck -- ck列
    ,item_cl -- cl列
    ,item_cm -- cm列
    ,item_cn -- cn列
    ,item_co -- co列
    ,item_cp -- cp列
    ,item_cq -- cq列
    ,item_cr -- cr列
    ,item_cs -- cs列
    ,item_ct -- ct列
    ,item_cu -- cu列
    ,item_cv -- cv列
    ,item_cw -- cw列
    ,item_cx -- cx列
    ,item_cy -- cy列
    ,item_cz -- cz列
    ,org_cd -- 机构编号
    ,ccy_cd -- 币种编号
    ,version -- 版本
    ,version_status -- 版本状态，1-保存，2-审批中，3-正式版本， 4-历史版本
    ,operate_dt -- 操作时间
    ,operate_id -- 操作人id
    ,operate_name -- 操作人姓名
    ,flow_starter_id -- 流程发起人id
    ,flow_starter_name -- 流程发起人姓名
    ,etl_dt -- ETL处理日期
    ,etl_timestamp -- ETL处理时间
)
select
    nvl(trim(data_id), ' ') as data_id -- 主键id
    ,nvl(trim(item_cd), ' ') as item_cd -- 报表编码
    ,nvl(trim(item_name), ' ') as item_name -- 报表名称
    ,nvl(trim(line_number), 0) as line_number -- 行号
    ,nvl(trim(item_a), ' ') as item_a -- a列
    ,nvl(trim(item_b), ' ') as item_b -- b列
    ,nvl(trim(item_c), ' ') as item_c -- c列
    ,nvl(trim(item_d), ' ') as item_d -- d列
    ,nvl(trim(item_e), ' ') as item_e -- e列
    ,nvl(trim(item_f), ' ') as item_f -- f列
    ,nvl(trim(item_g), ' ') as item_g -- g列
    ,nvl(trim(item_h), ' ') as item_h -- h列
    ,nvl(trim(item_i), ' ') as item_i -- i列
    ,nvl(trim(item_j), ' ') as item_j -- j列
    ,nvl(trim(item_k), ' ') as item_k -- k列
    ,nvl(trim(item_l), ' ') as item_l -- l列
    ,nvl(trim(item_m), ' ') as item_m -- m列
    ,nvl(trim(item_n), ' ') as item_n -- n列
    ,nvl(trim(item_o), ' ') as item_o -- o列
    ,nvl(trim(item_p), ' ') as item_p -- p列
    ,nvl(trim(item_q), ' ') as item_q -- q列
    ,nvl(trim(item_r), ' ') as item_r -- r列
    ,nvl(trim(item_s), ' ') as item_s -- s列
    ,nvl(trim(item_t), ' ') as item_t -- t列
    ,nvl(trim(item_u), ' ') as item_u -- u列
    ,nvl(trim(item_v), ' ') as item_v -- v列
    ,nvl(trim(item_w), ' ') as item_w -- w列
    ,nvl(trim(item_x), ' ') as item_x -- x列
    ,nvl(trim(item_y), ' ') as item_y -- y列
    ,nvl(trim(item_z), ' ') as item_z -- z列
    ,nvl(trim(item_aa), ' ') as item_aa -- aa列
    ,nvl(trim(item_ab), ' ') as item_ab -- ab列
    ,nvl(trim(item_ac), ' ') as item_ac -- ac列
    ,nvl(trim(item_ad), ' ') as item_ad -- ad列
    ,nvl(trim(item_ae), ' ') as item_ae -- ae列
    ,nvl(trim(item_af), ' ') as item_af -- af列
    ,nvl(trim(load_date), ' ') as load_date -- 加载时间
    ,nvl(trim(data_date), ' ') as data_date -- 数据日期(格式yyyymmdd)
    ,nvl(trim(solo_no), ' ') as solo_no -- 法人机构编号
    ,nvl(trim(item_ag), ' ') as item_ag -- ag列
    ,nvl(trim(item_ah), ' ') as item_ah -- ah列
    ,nvl(trim(item_ai), ' ') as item_ai -- ai列
    ,nvl(trim(item_aj), ' ') as item_aj -- aj列
    ,nvl(trim(item_ak), ' ') as item_ak -- ak列
    ,nvl(trim(item_al), ' ') as item_al -- al列
    ,nvl(trim(item_am), ' ') as item_am -- am列
    ,nvl(trim(item_an), ' ') as item_an -- an列
    ,nvl(trim(item_ao), ' ') as item_ao -- ao列
    ,nvl(trim(item_ap), ' ') as item_ap -- ap列
    ,nvl(trim(item_aq), ' ') as item_aq -- aq列
    ,nvl(trim(item_ar), ' ') as item_ar -- ar列
    ,nvl(trim(item_as), ' ') as item_as -- as列
    ,nvl(trim(item_at), ' ') as item_at -- at列
    ,nvl(trim(item_au), ' ') as item_au -- au列
    ,nvl(trim(item_av), ' ') as item_av -- av列
    ,nvl(trim(item_aw), ' ') as item_aw -- aw列
    ,nvl(trim(item_ax), ' ') as item_ax -- ax列
    ,nvl(trim(item_ay), ' ') as item_ay -- ay列
    ,nvl(trim(item_az), ' ') as item_az -- az列
    ,nvl(trim(item_ba), ' ') as item_ba -- ba列
    ,nvl(trim(item_bb), ' ') as item_bb -- bb列
    ,nvl(trim(item_bc), ' ') as item_bc -- bc列
    ,nvl(trim(item_bd), ' ') as item_bd -- bd列
    ,nvl(trim(item_be), ' ') as item_be -- be列
    ,nvl(trim(item_bf), ' ') as item_bf -- bf列
    ,nvl(trim(item_bg), ' ') as item_bg -- bg列
    ,nvl(trim(item_bh), ' ') as item_bh -- bh列
    ,nvl(trim(item_bi), ' ') as item_bi -- bi列
    ,nvl(trim(item_bj), ' ') as item_bj -- bj列
    ,nvl(trim(item_bk), ' ') as item_bk -- bk列
    ,nvl(trim(item_bl), ' ') as item_bl -- bl列
    ,nvl(trim(item_bm), ' ') as item_bm -- bm列
    ,nvl(trim(item_bn), ' ') as item_bn -- bn列
    ,nvl(trim(item_bo), ' ') as item_bo -- bo列
    ,nvl(trim(item_bp), ' ') as item_bp -- bp列
    ,nvl(trim(item_bq), ' ') as item_bq -- bq列
    ,nvl(trim(item_br), ' ') as item_br -- br列
    ,nvl(trim(item_bs), ' ') as item_bs -- bs列
    ,nvl(trim(item_bt), ' ') as item_bt -- bt列
    ,nvl(trim(item_bu), ' ') as item_bu -- bu列
    ,nvl(trim(item_bv), ' ') as item_bv -- bv列
    ,nvl(trim(item_bw), ' ') as item_bw -- bw列
    ,nvl(trim(item_bx), ' ') as item_bx -- bx列
    ,nvl(trim(item_by), ' ') as item_by -- by列
    ,nvl(trim(item_bz), ' ') as item_bz -- bz列
    ,nvl(trim(item_ca), ' ') as item_ca -- ca列
    ,nvl(trim(item_cb), ' ') as item_cb -- cb列
    ,nvl(trim(item_cc), ' ') as item_cc -- cc列
    ,nvl(trim(item_ccd), ' ') as item_ccd -- cd列
    ,nvl(trim(item_ce), ' ') as item_ce -- ce列
    ,nvl(trim(item_cf), ' ') as item_cf -- cf列
    ,nvl(trim(item_cg), ' ') as item_cg -- cg列
    ,nvl(trim(item_ch), ' ') as item_ch -- ch列
    ,nvl(trim(item_ci), ' ') as item_ci -- ci列
    ,nvl(trim(item_cj), ' ') as item_cj -- cj列
    ,nvl(trim(item_ck), ' ') as item_ck -- ck列
    ,nvl(trim(item_cl), ' ') as item_cl -- cl列
    ,nvl(trim(item_cm), ' ') as item_cm -- cm列
    ,nvl(trim(item_cn), ' ') as item_cn -- cn列
    ,nvl(trim(item_co), ' ') as item_co -- co列
    ,nvl(trim(item_cp), ' ') as item_cp -- cp列
    ,nvl(trim(item_cq), ' ') as item_cq -- cq列
    ,nvl(trim(item_cr), ' ') as item_cr -- cr列
    ,nvl(trim(item_cs), ' ') as item_cs -- cs列
    ,nvl(trim(item_ct), ' ') as item_ct -- ct列
    ,nvl(trim(item_cu), ' ') as item_cu -- cu列
    ,nvl(trim(item_cv), ' ') as item_cv -- cv列
    ,nvl(trim(item_cw), ' ') as item_cw -- cw列
    ,nvl(trim(item_cx), ' ') as item_cx -- cx列
    ,nvl(trim(item_cy), ' ') as item_cy -- cy列
    ,nvl(trim(item_cz), ' ') as item_cz -- cz列
    ,nvl(trim(org_cd), ' ') as org_cd -- 机构编号
    ,nvl(trim(ccy_cd), ' ') as ccy_cd -- 币种编号
    ,nvl(trim(version), ' ') as version -- 版本
    ,nvl(trim(version_status), 0) as version_status -- 版本状态，1-保存，2-审批中，3-正式版本， 4-历史版本
    ,nvl(trim(operate_dt), ' ') as operate_dt -- 操作时间
    ,nvl(trim(operate_id), ' ') as operate_id -- 操作人id
    ,nvl(trim(operate_name), ' ') as operate_name -- 操作人姓名
    ,nvl(trim(flow_starter_id), ' ') as flow_starter_id -- 流程发起人id
    ,nvl(trim(flow_starter_name), ' ') as flow_starter_name -- 流程发起人姓名
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from ${msl_schema}.msl_edw_rwas_pb_report_data_arc
where 1=1
 ;
commit;

-- 3 table grant
whenever sqlerror exit sql.sqlcode;
grant select on ${itl_schema}.itl_edw_rwas_pb_report_data_arc to ${iol_schema};

-- 4 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${itl_schema}',tabname => 'itl_edw_rwas_pb_report_data_arc',partname => 'p_${batch_date}', granularity => 'PARTITION', degree => 8, cascade => true);