/*
Purpose:    整合模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iml agt_fft_bus_info_h
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iml_schema}.agt_fft_bus_info_h
whenever sqlerror continue none;
drop table ${iml_schema}.agt_fft_bus_info_h purge;

whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.agt_fft_bus_info_h(
    agt_id varchar2(250) -- 协议编号
    ,lp_id varchar2(100) -- 法人编号
    ,intnal_id varchar2(100) -- 内部编号
    ,ref_no varchar2(60) -- 参考号
    ,lc_bus_id varchar2(100) -- 信用证业务编号
    ,tran_sketch varchar2(100) -- 交易简述
    ,pkg_buy_bk_comb varchar2(2000) -- 包买行组合
    ,present_id varchar2(100) -- 交单编号
    ,present_ps_name varchar2(500) -- 交单人名称
    ,rgst_dt date -- 登记日期
    ,open_dt date -- 开立日期
    ,open_exp_dt date -- 开立到期日期
    ,close_flg varchar2(10) -- 关闭标志
    ,close_dt date -- 关闭日期
    ,value_dt date -- 起息日期
    ,aldy_tran_sell_flg varchar2(10) -- 已转卖标志
    ,org_id varchar2(100) -- 机构编号
    ,parent_intnal_id varchar2(100) -- 父级内部编号
    ,parent_ref_no varchar2(60) -- 父级参考号
    ,parent_tran_abbr varchar2(500) -- 父级交易简称
    ,parent_tran_name varchar2(500) -- 父级交易名称
    ,inv_role_name varchar2(500) -- INV角色名称
    ,modif_dt date -- 修改日期
    ,modif_cnt number(10) -- 修改次数
    ,oper_teller_id varchar2(100) -- 经办柜员编号
    ,remark varchar2(500) -- 备注
    ,start_dt date -- 开始时间
    ,end_dt date -- 结束时间
    ,id_mark varchar2(10) -- 增删标志
    ,src_table_name varchar2(100) -- 源表名称
    ,job_cd varchar2(10) -- 任务编码
    ,etl_timestamp timestamp -- ETL处理时间戳
)
partition by list (job_cd)
subpartition by list (end_dt)
(
   partition p_default values ('default')
   (
         subpartition p_default_19000101 values (to_date('19000101','yyyymmdd'))
         ,subpartition p_default_20991231 values (to_date('20991231','yyyymmdd'))
   )
)
storage (initial 1024k next 1024k)
compress ${option_switch} for query high
nologging
;

-- grant
grant select on ${iml_schema}.agt_fft_bus_info_h to ${icl_schema};
grant select on ${iml_schema}.agt_fft_bus_info_h to ${idl_schema};
grant select on ${iml_schema}.agt_fft_bus_info_h to ${iel_schema};

-- comment
comment on table ${iml_schema}.agt_fft_bus_info_h is '福费廷业务信息历史';
comment on column ${iml_schema}.agt_fft_bus_info_h.agt_id is '协议编号';
comment on column ${iml_schema}.agt_fft_bus_info_h.lp_id is '法人编号';
comment on column ${iml_schema}.agt_fft_bus_info_h.intnal_id is '内部编号';
comment on column ${iml_schema}.agt_fft_bus_info_h.ref_no is '参考号';
comment on column ${iml_schema}.agt_fft_bus_info_h.lc_bus_id is '信用证业务编号';
comment on column ${iml_schema}.agt_fft_bus_info_h.tran_sketch is '交易简述';
comment on column ${iml_schema}.agt_fft_bus_info_h.pkg_buy_bk_comb is '包买行组合';
comment on column ${iml_schema}.agt_fft_bus_info_h.present_id is '交单编号';
comment on column ${iml_schema}.agt_fft_bus_info_h.present_ps_name is '交单人名称';
comment on column ${iml_schema}.agt_fft_bus_info_h.rgst_dt is '登记日期';
comment on column ${iml_schema}.agt_fft_bus_info_h.open_dt is '开立日期';
comment on column ${iml_schema}.agt_fft_bus_info_h.open_exp_dt is '开立到期日期';
comment on column ${iml_schema}.agt_fft_bus_info_h.close_flg is '关闭标志';
comment on column ${iml_schema}.agt_fft_bus_info_h.close_dt is '关闭日期';
comment on column ${iml_schema}.agt_fft_bus_info_h.value_dt is '起息日期';
comment on column ${iml_schema}.agt_fft_bus_info_h.aldy_tran_sell_flg is '已转卖标志';
comment on column ${iml_schema}.agt_fft_bus_info_h.org_id is '机构编号';
comment on column ${iml_schema}.agt_fft_bus_info_h.parent_intnal_id is '父级内部编号';
comment on column ${iml_schema}.agt_fft_bus_info_h.parent_ref_no is '父级参考号';
comment on column ${iml_schema}.agt_fft_bus_info_h.parent_tran_abbr is '父级交易简称';
comment on column ${iml_schema}.agt_fft_bus_info_h.parent_tran_name is '父级交易名称';
comment on column ${iml_schema}.agt_fft_bus_info_h.inv_role_name is 'INV角色名称';
comment on column ${iml_schema}.agt_fft_bus_info_h.modif_dt is '修改日期';
comment on column ${iml_schema}.agt_fft_bus_info_h.modif_cnt is '修改次数';
comment on column ${iml_schema}.agt_fft_bus_info_h.oper_teller_id is '经办柜员编号';
comment on column ${iml_schema}.agt_fft_bus_info_h.remark is '备注';
comment on column ${iml_schema}.agt_fft_bus_info_h.start_dt is '开始时间';
comment on column ${iml_schema}.agt_fft_bus_info_h.end_dt is '结束时间';
comment on column ${iml_schema}.agt_fft_bus_info_h.id_mark is '增删标志';
comment on column ${iml_schema}.agt_fft_bus_info_h.src_table_name is '源表名称';
comment on column ${iml_schema}.agt_fft_bus_info_h.job_cd is '任务编码';
comment on column ${iml_schema}.agt_fft_bus_info_h.etl_timestamp is 'ETL处理时间戳';
