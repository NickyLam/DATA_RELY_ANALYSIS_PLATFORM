/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_rwas_pb_report_data_arc
CreateDate: 20180515
Logs:
    zjj 2018-05-15 新建脚本
*/

set timing on

-- 1 alter parallel
alter session force parallel query parallel 8;
alter session force parallel dml parallel 8;
-- alter session force parallel ddl parallel 8;

-- 2.1 create backup table
-- if backup table is exists, mean script if failed on last time
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
create table ${iol_schema}.rwas_pb_report_data_arc_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.rwas_pb_report_data_arc
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.rwas_pb_report_data_arc_op purge;
drop table ${iol_schema}.rwas_pb_report_data_arc_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.rwas_pb_report_data_arc_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.rwas_pb_report_data_arc where 0=1;

create table ${iol_schema}.rwas_pb_report_data_arc_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.rwas_pb_report_data_arc where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.rwas_pb_report_data_arc_cl(
            data_id -- 主键ID
            ,item_cd -- 报表编码
            ,item_name -- 报表名称
            ,line_number -- 行号
            ,item_a -- A列
            ,item_b -- B列
            ,item_c -- C列
            ,item_d -- D列
            ,item_e -- E列
            ,item_f -- F列
            ,item_g -- G列
            ,item_h -- H列
            ,item_i -- I列
            ,item_j -- J列
            ,item_k -- K列
            ,item_l -- L列
            ,item_m -- M列
            ,item_n -- N列
            ,item_o -- O列
            ,item_p -- P列
            ,item_q -- Q列
            ,item_r -- R列
            ,item_s -- S列
            ,item_t -- T列
            ,item_u -- U列
            ,item_v -- V列
            ,item_w -- W列
            ,item_x -- X列
            ,item_y -- Y列
            ,item_z -- Z列
            ,item_aa -- AA列
            ,item_ab -- AB列
            ,item_ac -- AC列
            ,item_ad -- AD列
            ,item_ae -- AE列
            ,item_af -- AF列
            ,load_date -- 加载时间
            ,data_date -- 数据日期(格式YYYYMMDD)
            ,solo_no -- 法人机构编号
            ,item_ag -- AG列
            ,item_ah -- AH列
            ,item_ai -- AI列
            ,item_aj -- AJ列
            ,item_ak -- AK列
            ,item_al -- AL列
            ,item_am -- AM列
            ,item_an -- AN列
            ,item_ao -- AO列
            ,item_ap -- AP列
            ,item_aq -- AQ列
            ,item_ar -- AR列
            ,item_as -- AS列
            ,item_at -- AT列
            ,item_au -- AU列
            ,item_av -- AV列
            ,item_aw -- AW列
            ,item_ax -- AX列
            ,item_ay -- AY列
            ,item_az -- AZ列
            ,item_ba -- BA列
            ,item_bb -- BB列
            ,item_bc -- BC列
            ,item_bd -- BD列
            ,item_be -- BE列
            ,item_bf -- BF列
            ,item_bg -- BG列
            ,item_bh -- BH列
            ,item_bi -- BI列
            ,item_bj -- BJ列
            ,item_bk -- BK列
            ,item_bl -- BL列
            ,item_bm -- BM列
            ,item_bn -- BN列
            ,item_bo -- BO列
            ,item_bp -- BP列
            ,item_bq -- BQ列
            ,item_br -- BR列
            ,item_bs -- BS列
            ,item_bt -- BT列
            ,item_bu -- BU列
            ,item_bv -- BV列
            ,item_bw -- BW列
            ,item_bx -- BX列
            ,item_by -- BY列
            ,item_bz -- BZ列
            ,item_ca -- CA列
            ,item_cb -- CB列
            ,item_cc -- CC列
            ,item_ccd -- CD列
            ,item_ce -- CE列
            ,item_cf -- CF列
            ,item_cg -- CG列
            ,item_ch -- CH列
            ,item_ci -- CI列
            ,item_cj -- CJ列
            ,item_ck -- CK列
            ,item_cl -- CL列
            ,item_cm -- CM列
            ,item_cn -- CN列
            ,item_co -- CO列
            ,item_cp -- CP列
            ,item_cq -- CQ列
            ,item_cr -- CR列
            ,item_cs -- CS列
            ,item_ct -- CT列
            ,item_cu -- CU列
            ,item_cv -- CV列
            ,item_cw -- CW列
            ,item_cx -- CX列
            ,item_cy -- CY列
            ,item_cz -- CZ列
            ,org_cd -- 机构编号
            ,ccy_cd -- 币种编号
            ,version -- 版本
            ,version_status -- 版本状态，1-保存，2-审批中，3-正式版本， 4-历史版本
            ,operate_dt -- 操作时间
            ,operate_id -- 操作人ID
            ,operate_name -- 操作人姓名
            ,flow_starter_id -- 流程发起人ID
            ,flow_starter_name -- 流程发起人姓名
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.rwas_pb_report_data_arc_op(
            data_id -- 主键ID
            ,item_cd -- 报表编码
            ,item_name -- 报表名称
            ,line_number -- 行号
            ,item_a -- A列
            ,item_b -- B列
            ,item_c -- C列
            ,item_d -- D列
            ,item_e -- E列
            ,item_f -- F列
            ,item_g -- G列
            ,item_h -- H列
            ,item_i -- I列
            ,item_j -- J列
            ,item_k -- K列
            ,item_l -- L列
            ,item_m -- M列
            ,item_n -- N列
            ,item_o -- O列
            ,item_p -- P列
            ,item_q -- Q列
            ,item_r -- R列
            ,item_s -- S列
            ,item_t -- T列
            ,item_u -- U列
            ,item_v -- V列
            ,item_w -- W列
            ,item_x -- X列
            ,item_y -- Y列
            ,item_z -- Z列
            ,item_aa -- AA列
            ,item_ab -- AB列
            ,item_ac -- AC列
            ,item_ad -- AD列
            ,item_ae -- AE列
            ,item_af -- AF列
            ,load_date -- 加载时间
            ,data_date -- 数据日期(格式YYYYMMDD)
            ,solo_no -- 法人机构编号
            ,item_ag -- AG列
            ,item_ah -- AH列
            ,item_ai -- AI列
            ,item_aj -- AJ列
            ,item_ak -- AK列
            ,item_al -- AL列
            ,item_am -- AM列
            ,item_an -- AN列
            ,item_ao -- AO列
            ,item_ap -- AP列
            ,item_aq -- AQ列
            ,item_ar -- AR列
            ,item_as -- AS列
            ,item_at -- AT列
            ,item_au -- AU列
            ,item_av -- AV列
            ,item_aw -- AW列
            ,item_ax -- AX列
            ,item_ay -- AY列
            ,item_az -- AZ列
            ,item_ba -- BA列
            ,item_bb -- BB列
            ,item_bc -- BC列
            ,item_bd -- BD列
            ,item_be -- BE列
            ,item_bf -- BF列
            ,item_bg -- BG列
            ,item_bh -- BH列
            ,item_bi -- BI列
            ,item_bj -- BJ列
            ,item_bk -- BK列
            ,item_bl -- BL列
            ,item_bm -- BM列
            ,item_bn -- BN列
            ,item_bo -- BO列
            ,item_bp -- BP列
            ,item_bq -- BQ列
            ,item_br -- BR列
            ,item_bs -- BS列
            ,item_bt -- BT列
            ,item_bu -- BU列
            ,item_bv -- BV列
            ,item_bw -- BW列
            ,item_bx -- BX列
            ,item_by -- BY列
            ,item_bz -- BZ列
            ,item_ca -- CA列
            ,item_cb -- CB列
            ,item_cc -- CC列
            ,item_ccd -- CD列
            ,item_ce -- CE列
            ,item_cf -- CF列
            ,item_cg -- CG列
            ,item_ch -- CH列
            ,item_ci -- CI列
            ,item_cj -- CJ列
            ,item_ck -- CK列
            ,item_cl -- CL列
            ,item_cm -- CM列
            ,item_cn -- CN列
            ,item_co -- CO列
            ,item_cp -- CP列
            ,item_cq -- CQ列
            ,item_cr -- CR列
            ,item_cs -- CS列
            ,item_ct -- CT列
            ,item_cu -- CU列
            ,item_cv -- CV列
            ,item_cw -- CW列
            ,item_cx -- CX列
            ,item_cy -- CY列
            ,item_cz -- CZ列
            ,org_cd -- 机构编号
            ,ccy_cd -- 币种编号
            ,version -- 版本
            ,version_status -- 版本状态，1-保存，2-审批中，3-正式版本， 4-历史版本
            ,operate_dt -- 操作时间
            ,operate_id -- 操作人ID
            ,operate_name -- 操作人姓名
            ,flow_starter_id -- 流程发起人ID
            ,flow_starter_name -- 流程发起人姓名
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.data_id, o.data_id) as data_id -- 主键ID
    ,nvl(n.item_cd, o.item_cd) as item_cd -- 报表编码
    ,nvl(n.item_name, o.item_name) as item_name -- 报表名称
    ,nvl(n.line_number, o.line_number) as line_number -- 行号
    ,nvl(n.item_a, o.item_a) as item_a -- A列
    ,nvl(n.item_b, o.item_b) as item_b -- B列
    ,nvl(n.item_c, o.item_c) as item_c -- C列
    ,nvl(n.item_d, o.item_d) as item_d -- D列
    ,nvl(n.item_e, o.item_e) as item_e -- E列
    ,nvl(n.item_f, o.item_f) as item_f -- F列
    ,nvl(n.item_g, o.item_g) as item_g -- G列
    ,nvl(n.item_h, o.item_h) as item_h -- H列
    ,nvl(n.item_i, o.item_i) as item_i -- I列
    ,nvl(n.item_j, o.item_j) as item_j -- J列
    ,nvl(n.item_k, o.item_k) as item_k -- K列
    ,nvl(n.item_l, o.item_l) as item_l -- L列
    ,nvl(n.item_m, o.item_m) as item_m -- M列
    ,nvl(n.item_n, o.item_n) as item_n -- N列
    ,nvl(n.item_o, o.item_o) as item_o -- O列
    ,nvl(n.item_p, o.item_p) as item_p -- P列
    ,nvl(n.item_q, o.item_q) as item_q -- Q列
    ,nvl(n.item_r, o.item_r) as item_r -- R列
    ,nvl(n.item_s, o.item_s) as item_s -- S列
    ,nvl(n.item_t, o.item_t) as item_t -- T列
    ,nvl(n.item_u, o.item_u) as item_u -- U列
    ,nvl(n.item_v, o.item_v) as item_v -- V列
    ,nvl(n.item_w, o.item_w) as item_w -- W列
    ,nvl(n.item_x, o.item_x) as item_x -- X列
    ,nvl(n.item_y, o.item_y) as item_y -- Y列
    ,nvl(n.item_z, o.item_z) as item_z -- Z列
    ,nvl(n.item_aa, o.item_aa) as item_aa -- AA列
    ,nvl(n.item_ab, o.item_ab) as item_ab -- AB列
    ,nvl(n.item_ac, o.item_ac) as item_ac -- AC列
    ,nvl(n.item_ad, o.item_ad) as item_ad -- AD列
    ,nvl(n.item_ae, o.item_ae) as item_ae -- AE列
    ,nvl(n.item_af, o.item_af) as item_af -- AF列
    ,nvl(n.load_date, o.load_date) as load_date -- 加载时间
    ,nvl(n.data_date, o.data_date) as data_date -- 数据日期(格式YYYYMMDD)
    ,nvl(n.solo_no, o.solo_no) as solo_no -- 法人机构编号
    ,nvl(n.item_ag, o.item_ag) as item_ag -- AG列
    ,nvl(n.item_ah, o.item_ah) as item_ah -- AH列
    ,nvl(n.item_ai, o.item_ai) as item_ai -- AI列
    ,nvl(n.item_aj, o.item_aj) as item_aj -- AJ列
    ,nvl(n.item_ak, o.item_ak) as item_ak -- AK列
    ,nvl(n.item_al, o.item_al) as item_al -- AL列
    ,nvl(n.item_am, o.item_am) as item_am -- AM列
    ,nvl(n.item_an, o.item_an) as item_an -- AN列
    ,nvl(n.item_ao, o.item_ao) as item_ao -- AO列
    ,nvl(n.item_ap, o.item_ap) as item_ap -- AP列
    ,nvl(n.item_aq, o.item_aq) as item_aq -- AQ列
    ,nvl(n.item_ar, o.item_ar) as item_ar -- AR列
    ,nvl(n.item_as, o.item_as) as item_as -- AS列
    ,nvl(n.item_at, o.item_at) as item_at -- AT列
    ,nvl(n.item_au, o.item_au) as item_au -- AU列
    ,nvl(n.item_av, o.item_av) as item_av -- AV列
    ,nvl(n.item_aw, o.item_aw) as item_aw -- AW列
    ,nvl(n.item_ax, o.item_ax) as item_ax -- AX列
    ,nvl(n.item_ay, o.item_ay) as item_ay -- AY列
    ,nvl(n.item_az, o.item_az) as item_az -- AZ列
    ,nvl(n.item_ba, o.item_ba) as item_ba -- BA列
    ,nvl(n.item_bb, o.item_bb) as item_bb -- BB列
    ,nvl(n.item_bc, o.item_bc) as item_bc -- BC列
    ,nvl(n.item_bd, o.item_bd) as item_bd -- BD列
    ,nvl(n.item_be, o.item_be) as item_be -- BE列
    ,nvl(n.item_bf, o.item_bf) as item_bf -- BF列
    ,nvl(n.item_bg, o.item_bg) as item_bg -- BG列
    ,nvl(n.item_bh, o.item_bh) as item_bh -- BH列
    ,nvl(n.item_bi, o.item_bi) as item_bi -- BI列
    ,nvl(n.item_bj, o.item_bj) as item_bj -- BJ列
    ,nvl(n.item_bk, o.item_bk) as item_bk -- BK列
    ,nvl(n.item_bl, o.item_bl) as item_bl -- BL列
    ,nvl(n.item_bm, o.item_bm) as item_bm -- BM列
    ,nvl(n.item_bn, o.item_bn) as item_bn -- BN列
    ,nvl(n.item_bo, o.item_bo) as item_bo -- BO列
    ,nvl(n.item_bp, o.item_bp) as item_bp -- BP列
    ,nvl(n.item_bq, o.item_bq) as item_bq -- BQ列
    ,nvl(n.item_br, o.item_br) as item_br -- BR列
    ,nvl(n.item_bs, o.item_bs) as item_bs -- BS列
    ,nvl(n.item_bt, o.item_bt) as item_bt -- BT列
    ,nvl(n.item_bu, o.item_bu) as item_bu -- BU列
    ,nvl(n.item_bv, o.item_bv) as item_bv -- BV列
    ,nvl(n.item_bw, o.item_bw) as item_bw -- BW列
    ,nvl(n.item_bx, o.item_bx) as item_bx -- BX列
    ,nvl(n.item_by, o.item_by) as item_by -- BY列
    ,nvl(n.item_bz, o.item_bz) as item_bz -- BZ列
    ,nvl(n.item_ca, o.item_ca) as item_ca -- CA列
    ,nvl(n.item_cb, o.item_cb) as item_cb -- CB列
    ,nvl(n.item_cc, o.item_cc) as item_cc -- CC列
    ,nvl(n.item_ccd, o.item_ccd) as item_ccd -- CD列
    ,nvl(n.item_ce, o.item_ce) as item_ce -- CE列
    ,nvl(n.item_cf, o.item_cf) as item_cf -- CF列
    ,nvl(n.item_cg, o.item_cg) as item_cg -- CG列
    ,nvl(n.item_ch, o.item_ch) as item_ch -- CH列
    ,nvl(n.item_ci, o.item_ci) as item_ci -- CI列
    ,nvl(n.item_cj, o.item_cj) as item_cj -- CJ列
    ,nvl(n.item_ck, o.item_ck) as item_ck -- CK列
    ,nvl(n.item_cl, o.item_cl) as item_cl -- CL列
    ,nvl(n.item_cm, o.item_cm) as item_cm -- CM列
    ,nvl(n.item_cn, o.item_cn) as item_cn -- CN列
    ,nvl(n.item_co, o.item_co) as item_co -- CO列
    ,nvl(n.item_cp, o.item_cp) as item_cp -- CP列
    ,nvl(n.item_cq, o.item_cq) as item_cq -- CQ列
    ,nvl(n.item_cr, o.item_cr) as item_cr -- CR列
    ,nvl(n.item_cs, o.item_cs) as item_cs -- CS列
    ,nvl(n.item_ct, o.item_ct) as item_ct -- CT列
    ,nvl(n.item_cu, o.item_cu) as item_cu -- CU列
    ,nvl(n.item_cv, o.item_cv) as item_cv -- CV列
    ,nvl(n.item_cw, o.item_cw) as item_cw -- CW列
    ,nvl(n.item_cx, o.item_cx) as item_cx -- CX列
    ,nvl(n.item_cy, o.item_cy) as item_cy -- CY列
    ,nvl(n.item_cz, o.item_cz) as item_cz -- CZ列
    ,nvl(n.org_cd, o.org_cd) as org_cd -- 机构编号
    ,nvl(n.ccy_cd, o.ccy_cd) as ccy_cd -- 币种编号
    ,nvl(n.version, o.version) as version -- 版本
    ,nvl(n.version_status, o.version_status) as version_status -- 版本状态，1-保存，2-审批中，3-正式版本， 4-历史版本
    ,nvl(n.operate_dt, o.operate_dt) as operate_dt -- 操作时间
    ,nvl(n.operate_id, o.operate_id) as operate_id -- 操作人ID
    ,nvl(n.operate_name, o.operate_name) as operate_name -- 操作人姓名
    ,nvl(n.flow_starter_id, o.flow_starter_id) as flow_starter_id -- 流程发起人ID
    ,nvl(n.flow_starter_name, o.flow_starter_name) as flow_starter_name -- 流程发起人姓名
    ,case when
            n.data_id is null
            and n.item_cd is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.data_id is null
            and n.item_cd is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.data_id is null
            and n.item_cd is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.rwas_pb_report_data_arc_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.rwas_pb_report_data_arc where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.data_id = n.data_id
            and o.item_cd = n.item_cd
where (
        o.data_id is null
        and o.item_cd is null
    )
    or (
        n.data_id is null
        and n.item_cd is null
    )
    or (
        o.item_name <> n.item_name
        or o.line_number <> n.line_number
        or o.item_a <> n.item_a
        or o.item_b <> n.item_b
        or o.item_c <> n.item_c
        or o.item_d <> n.item_d
        or o.item_e <> n.item_e
        or o.item_f <> n.item_f
        or o.item_g <> n.item_g
        or o.item_h <> n.item_h
        or o.item_i <> n.item_i
        or o.item_j <> n.item_j
        or o.item_k <> n.item_k
        or o.item_l <> n.item_l
        or o.item_m <> n.item_m
        or o.item_n <> n.item_n
        or o.item_o <> n.item_o
        or o.item_p <> n.item_p
        or o.item_q <> n.item_q
        or o.item_r <> n.item_r
        or o.item_s <> n.item_s
        or o.item_t <> n.item_t
        or o.item_u <> n.item_u
        or o.item_v <> n.item_v
        or o.item_w <> n.item_w
        or o.item_x <> n.item_x
        or o.item_y <> n.item_y
        or o.item_z <> n.item_z
        or o.item_aa <> n.item_aa
        or o.item_ab <> n.item_ab
        or o.item_ac <> n.item_ac
        or o.item_ad <> n.item_ad
        or o.item_ae <> n.item_ae
        or o.item_af <> n.item_af
        or o.load_date <> n.load_date
        or o.data_date <> n.data_date
        or o.solo_no <> n.solo_no
        or o.item_ag <> n.item_ag
        or o.item_ah <> n.item_ah
        or o.item_ai <> n.item_ai
        or o.item_aj <> n.item_aj
        or o.item_ak <> n.item_ak
        or o.item_al <> n.item_al
        or o.item_am <> n.item_am
        or o.item_an <> n.item_an
        or o.item_ao <> n.item_ao
        or o.item_ap <> n.item_ap
        or o.item_aq <> n.item_aq
        or o.item_ar <> n.item_ar
        or o.item_as <> n.item_as
        or o.item_at <> n.item_at
        or o.item_au <> n.item_au
        or o.item_av <> n.item_av
        or o.item_aw <> n.item_aw
        or o.item_ax <> n.item_ax
        or o.item_ay <> n.item_ay
        or o.item_az <> n.item_az
        or o.item_ba <> n.item_ba
        or o.item_bb <> n.item_bb
        or o.item_bc <> n.item_bc
        or o.item_bd <> n.item_bd
        or o.item_be <> n.item_be
        or o.item_bf <> n.item_bf
        or o.item_bg <> n.item_bg
        or o.item_bh <> n.item_bh
        or o.item_bi <> n.item_bi
        or o.item_bj <> n.item_bj
        or o.item_bk <> n.item_bk
        or o.item_bl <> n.item_bl
        or o.item_bm <> n.item_bm
        or o.item_bn <> n.item_bn
        or o.item_bo <> n.item_bo
        or o.item_bp <> n.item_bp
        or o.item_bq <> n.item_bq
        or o.item_br <> n.item_br
        or o.item_bs <> n.item_bs
        or o.item_bt <> n.item_bt
        or o.item_bu <> n.item_bu
        or o.item_bv <> n.item_bv
        or o.item_bw <> n.item_bw
        or o.item_bx <> n.item_bx
        or o.item_by <> n.item_by
        or o.item_bz <> n.item_bz
        or o.item_ca <> n.item_ca
        or o.item_cb <> n.item_cb
        or o.item_cc <> n.item_cc
        or o.item_ccd <> n.item_ccd
        or o.item_ce <> n.item_ce
        or o.item_cf <> n.item_cf
        or o.item_cg <> n.item_cg
        or o.item_ch <> n.item_ch
        or o.item_ci <> n.item_ci
        or o.item_cj <> n.item_cj
        or o.item_ck <> n.item_ck
        or o.item_cl <> n.item_cl
        or o.item_cm <> n.item_cm
        or o.item_cn <> n.item_cn
        or o.item_co <> n.item_co
        or o.item_cp <> n.item_cp
        or o.item_cq <> n.item_cq
        or o.item_cr <> n.item_cr
        or o.item_cs <> n.item_cs
        or o.item_ct <> n.item_ct
        or o.item_cu <> n.item_cu
        or o.item_cv <> n.item_cv
        or o.item_cw <> n.item_cw
        or o.item_cx <> n.item_cx
        or o.item_cy <> n.item_cy
        or o.item_cz <> n.item_cz
        or o.org_cd <> n.org_cd
        or o.ccy_cd <> n.ccy_cd
        or o.version <> n.version
        or o.version_status <> n.version_status
        or o.operate_dt <> n.operate_dt
        or o.operate_id <> n.operate_id
        or o.operate_name <> n.operate_name
        or o.flow_starter_id <> n.flow_starter_id
        or o.flow_starter_name <> n.flow_starter_name
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.rwas_pb_report_data_arc_cl(
            data_id -- 主键ID
            ,item_cd -- 报表编码
            ,item_name -- 报表名称
            ,line_number -- 行号
            ,item_a -- A列
            ,item_b -- B列
            ,item_c -- C列
            ,item_d -- D列
            ,item_e -- E列
            ,item_f -- F列
            ,item_g -- G列
            ,item_h -- H列
            ,item_i -- I列
            ,item_j -- J列
            ,item_k -- K列
            ,item_l -- L列
            ,item_m -- M列
            ,item_n -- N列
            ,item_o -- O列
            ,item_p -- P列
            ,item_q -- Q列
            ,item_r -- R列
            ,item_s -- S列
            ,item_t -- T列
            ,item_u -- U列
            ,item_v -- V列
            ,item_w -- W列
            ,item_x -- X列
            ,item_y -- Y列
            ,item_z -- Z列
            ,item_aa -- AA列
            ,item_ab -- AB列
            ,item_ac -- AC列
            ,item_ad -- AD列
            ,item_ae -- AE列
            ,item_af -- AF列
            ,load_date -- 加载时间
            ,data_date -- 数据日期(格式YYYYMMDD)
            ,solo_no -- 法人机构编号
            ,item_ag -- AG列
            ,item_ah -- AH列
            ,item_ai -- AI列
            ,item_aj -- AJ列
            ,item_ak -- AK列
            ,item_al -- AL列
            ,item_am -- AM列
            ,item_an -- AN列
            ,item_ao -- AO列
            ,item_ap -- AP列
            ,item_aq -- AQ列
            ,item_ar -- AR列
            ,item_as -- AS列
            ,item_at -- AT列
            ,item_au -- AU列
            ,item_av -- AV列
            ,item_aw -- AW列
            ,item_ax -- AX列
            ,item_ay -- AY列
            ,item_az -- AZ列
            ,item_ba -- BA列
            ,item_bb -- BB列
            ,item_bc -- BC列
            ,item_bd -- BD列
            ,item_be -- BE列
            ,item_bf -- BF列
            ,item_bg -- BG列
            ,item_bh -- BH列
            ,item_bi -- BI列
            ,item_bj -- BJ列
            ,item_bk -- BK列
            ,item_bl -- BL列
            ,item_bm -- BM列
            ,item_bn -- BN列
            ,item_bo -- BO列
            ,item_bp -- BP列
            ,item_bq -- BQ列
            ,item_br -- BR列
            ,item_bs -- BS列
            ,item_bt -- BT列
            ,item_bu -- BU列
            ,item_bv -- BV列
            ,item_bw -- BW列
            ,item_bx -- BX列
            ,item_by -- BY列
            ,item_bz -- BZ列
            ,item_ca -- CA列
            ,item_cb -- CB列
            ,item_cc -- CC列
            ,item_ccd -- CD列
            ,item_ce -- CE列
            ,item_cf -- CF列
            ,item_cg -- CG列
            ,item_ch -- CH列
            ,item_ci -- CI列
            ,item_cj -- CJ列
            ,item_ck -- CK列
            ,item_cl -- CL列
            ,item_cm -- CM列
            ,item_cn -- CN列
            ,item_co -- CO列
            ,item_cp -- CP列
            ,item_cq -- CQ列
            ,item_cr -- CR列
            ,item_cs -- CS列
            ,item_ct -- CT列
            ,item_cu -- CU列
            ,item_cv -- CV列
            ,item_cw -- CW列
            ,item_cx -- CX列
            ,item_cy -- CY列
            ,item_cz -- CZ列
            ,org_cd -- 机构编号
            ,ccy_cd -- 币种编号
            ,version -- 版本
            ,version_status -- 版本状态，1-保存，2-审批中，3-正式版本， 4-历史版本
            ,operate_dt -- 操作时间
            ,operate_id -- 操作人ID
            ,operate_name -- 操作人姓名
            ,flow_starter_id -- 流程发起人ID
            ,flow_starter_name -- 流程发起人姓名
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.rwas_pb_report_data_arc_op(
            data_id -- 主键ID
            ,item_cd -- 报表编码
            ,item_name -- 报表名称
            ,line_number -- 行号
            ,item_a -- A列
            ,item_b -- B列
            ,item_c -- C列
            ,item_d -- D列
            ,item_e -- E列
            ,item_f -- F列
            ,item_g -- G列
            ,item_h -- H列
            ,item_i -- I列
            ,item_j -- J列
            ,item_k -- K列
            ,item_l -- L列
            ,item_m -- M列
            ,item_n -- N列
            ,item_o -- O列
            ,item_p -- P列
            ,item_q -- Q列
            ,item_r -- R列
            ,item_s -- S列
            ,item_t -- T列
            ,item_u -- U列
            ,item_v -- V列
            ,item_w -- W列
            ,item_x -- X列
            ,item_y -- Y列
            ,item_z -- Z列
            ,item_aa -- AA列
            ,item_ab -- AB列
            ,item_ac -- AC列
            ,item_ad -- AD列
            ,item_ae -- AE列
            ,item_af -- AF列
            ,load_date -- 加载时间
            ,data_date -- 数据日期(格式YYYYMMDD)
            ,solo_no -- 法人机构编号
            ,item_ag -- AG列
            ,item_ah -- AH列
            ,item_ai -- AI列
            ,item_aj -- AJ列
            ,item_ak -- AK列
            ,item_al -- AL列
            ,item_am -- AM列
            ,item_an -- AN列
            ,item_ao -- AO列
            ,item_ap -- AP列
            ,item_aq -- AQ列
            ,item_ar -- AR列
            ,item_as -- AS列
            ,item_at -- AT列
            ,item_au -- AU列
            ,item_av -- AV列
            ,item_aw -- AW列
            ,item_ax -- AX列
            ,item_ay -- AY列
            ,item_az -- AZ列
            ,item_ba -- BA列
            ,item_bb -- BB列
            ,item_bc -- BC列
            ,item_bd -- BD列
            ,item_be -- BE列
            ,item_bf -- BF列
            ,item_bg -- BG列
            ,item_bh -- BH列
            ,item_bi -- BI列
            ,item_bj -- BJ列
            ,item_bk -- BK列
            ,item_bl -- BL列
            ,item_bm -- BM列
            ,item_bn -- BN列
            ,item_bo -- BO列
            ,item_bp -- BP列
            ,item_bq -- BQ列
            ,item_br -- BR列
            ,item_bs -- BS列
            ,item_bt -- BT列
            ,item_bu -- BU列
            ,item_bv -- BV列
            ,item_bw -- BW列
            ,item_bx -- BX列
            ,item_by -- BY列
            ,item_bz -- BZ列
            ,item_ca -- CA列
            ,item_cb -- CB列
            ,item_cc -- CC列
            ,item_ccd -- CD列
            ,item_ce -- CE列
            ,item_cf -- CF列
            ,item_cg -- CG列
            ,item_ch -- CH列
            ,item_ci -- CI列
            ,item_cj -- CJ列
            ,item_ck -- CK列
            ,item_cl -- CL列
            ,item_cm -- CM列
            ,item_cn -- CN列
            ,item_co -- CO列
            ,item_cp -- CP列
            ,item_cq -- CQ列
            ,item_cr -- CR列
            ,item_cs -- CS列
            ,item_ct -- CT列
            ,item_cu -- CU列
            ,item_cv -- CV列
            ,item_cw -- CW列
            ,item_cx -- CX列
            ,item_cy -- CY列
            ,item_cz -- CZ列
            ,org_cd -- 机构编号
            ,ccy_cd -- 币种编号
            ,version -- 版本
            ,version_status -- 版本状态，1-保存，2-审批中，3-正式版本， 4-历史版本
            ,operate_dt -- 操作时间
            ,operate_id -- 操作人ID
            ,operate_name -- 操作人姓名
            ,flow_starter_id -- 流程发起人ID
            ,flow_starter_name -- 流程发起人姓名
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.data_id -- 主键ID
    ,o.item_cd -- 报表编码
    ,o.item_name -- 报表名称
    ,o.line_number -- 行号
    ,o.item_a -- A列
    ,o.item_b -- B列
    ,o.item_c -- C列
    ,o.item_d -- D列
    ,o.item_e -- E列
    ,o.item_f -- F列
    ,o.item_g -- G列
    ,o.item_h -- H列
    ,o.item_i -- I列
    ,o.item_j -- J列
    ,o.item_k -- K列
    ,o.item_l -- L列
    ,o.item_m -- M列
    ,o.item_n -- N列
    ,o.item_o -- O列
    ,o.item_p -- P列
    ,o.item_q -- Q列
    ,o.item_r -- R列
    ,o.item_s -- S列
    ,o.item_t -- T列
    ,o.item_u -- U列
    ,o.item_v -- V列
    ,o.item_w -- W列
    ,o.item_x -- X列
    ,o.item_y -- Y列
    ,o.item_z -- Z列
    ,o.item_aa -- AA列
    ,o.item_ab -- AB列
    ,o.item_ac -- AC列
    ,o.item_ad -- AD列
    ,o.item_ae -- AE列
    ,o.item_af -- AF列
    ,o.load_date -- 加载时间
    ,o.data_date -- 数据日期(格式YYYYMMDD)
    ,o.solo_no -- 法人机构编号
    ,o.item_ag -- AG列
    ,o.item_ah -- AH列
    ,o.item_ai -- AI列
    ,o.item_aj -- AJ列
    ,o.item_ak -- AK列
    ,o.item_al -- AL列
    ,o.item_am -- AM列
    ,o.item_an -- AN列
    ,o.item_ao -- AO列
    ,o.item_ap -- AP列
    ,o.item_aq -- AQ列
    ,o.item_ar -- AR列
    ,o.item_as -- AS列
    ,o.item_at -- AT列
    ,o.item_au -- AU列
    ,o.item_av -- AV列
    ,o.item_aw -- AW列
    ,o.item_ax -- AX列
    ,o.item_ay -- AY列
    ,o.item_az -- AZ列
    ,o.item_ba -- BA列
    ,o.item_bb -- BB列
    ,o.item_bc -- BC列
    ,o.item_bd -- BD列
    ,o.item_be -- BE列
    ,o.item_bf -- BF列
    ,o.item_bg -- BG列
    ,o.item_bh -- BH列
    ,o.item_bi -- BI列
    ,o.item_bj -- BJ列
    ,o.item_bk -- BK列
    ,o.item_bl -- BL列
    ,o.item_bm -- BM列
    ,o.item_bn -- BN列
    ,o.item_bo -- BO列
    ,o.item_bp -- BP列
    ,o.item_bq -- BQ列
    ,o.item_br -- BR列
    ,o.item_bs -- BS列
    ,o.item_bt -- BT列
    ,o.item_bu -- BU列
    ,o.item_bv -- BV列
    ,o.item_bw -- BW列
    ,o.item_bx -- BX列
    ,o.item_by -- BY列
    ,o.item_bz -- BZ列
    ,o.item_ca -- CA列
    ,o.item_cb -- CB列
    ,o.item_cc -- CC列
    ,o.item_ccd -- CD列
    ,o.item_ce -- CE列
    ,o.item_cf -- CF列
    ,o.item_cg -- CG列
    ,o.item_ch -- CH列
    ,o.item_ci -- CI列
    ,o.item_cj -- CJ列
    ,o.item_ck -- CK列
    ,o.item_cl -- CL列
    ,o.item_cm -- CM列
    ,o.item_cn -- CN列
    ,o.item_co -- CO列
    ,o.item_cp -- CP列
    ,o.item_cq -- CQ列
    ,o.item_cr -- CR列
    ,o.item_cs -- CS列
    ,o.item_ct -- CT列
    ,o.item_cu -- CU列
    ,o.item_cv -- CV列
    ,o.item_cw -- CW列
    ,o.item_cx -- CX列
    ,o.item_cy -- CY列
    ,o.item_cz -- CZ列
    ,o.org_cd -- 机构编号
    ,o.ccy_cd -- 币种编号
    ,o.version -- 版本
    ,o.version_status -- 版本状态，1-保存，2-审批中，3-正式版本， 4-历史版本
    ,o.operate_dt -- 操作时间
    ,o.operate_id -- 操作人ID
    ,o.operate_name -- 操作人姓名
    ,o.flow_starter_id -- 流程发起人ID
    ,o.flow_starter_name -- 流程发起人姓名
    ,o.start_dt -- 开始时间
    ,case when n.start_dt is not null then to_date('${batch_date}', 'yyyymmdd')
          when o.end_dt >= to_date('${batch_date}','yyyymmdd') then to_date('20991231','yyyymmdd')
          else o.end_dt
     end as end_dt -- 结束时间
    ,case when n.start_dt is not null
          then 'I'
          when o.end_dt >= to_date('${batch_date}','yyyymmdd')
          then 'I'
          else o.id_mark
     end as id_mark  -- 增删标志 
    ,o.etl_timestamp -- ETL处理时间
from ${iol_schema}.rwas_pb_report_data_arc_bk o
    left join ${iol_schema}.rwas_pb_report_data_arc_op n
        on
            o.data_id = n.data_id
            and o.item_cd = n.item_cd
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.rwas_pb_report_data_arc_cl d
        on
            o.data_id = d.data_id
            and o.item_cd = d.item_cd
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
--truncate table ${iol_schema}.rwas_pb_report_data_arc;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('rwas_pb_report_data_arc') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.rwas_pb_report_data_arc drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.rwas_pb_report_data_arc add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.rwas_pb_report_data_arc exchange partition p_${batch_date} with table ${iol_schema}.rwas_pb_report_data_arc_cl;
alter table ${iol_schema}.rwas_pb_report_data_arc exchange partition p_20991231 with table ${iol_schema}.rwas_pb_report_data_arc_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.rwas_pb_report_data_arc to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.rwas_pb_report_data_arc_op purge;
drop table ${iol_schema}.rwas_pb_report_data_arc_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.rwas_pb_report_data_arc_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'rwas_pb_report_data_arc',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
