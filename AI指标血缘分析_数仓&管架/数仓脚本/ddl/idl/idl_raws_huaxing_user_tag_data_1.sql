/*
Purpose:    应用集市层-建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py idl raws_huaxing_user_tag_data_1
CreateDate: 20221105
FileType:   DDL
Logs:
    sundexin
*/

prompt creating table ${idl_schema}.raws_huaxing_user_tag_data_1
whenever sqlerror continue none;
drop table ${idl_schema}.raws_huaxing_user_tag_data_1 purge;

whenever sqlerror exit sql.sqlcode;
create table ${idl_schema}.raws_huaxing_user_tag_data_1(
    etl_dt                                date           -- 数据日期    
    ,user_id                              varchar2(4000)
    ,user_tag_ykhwm30twqdayh              varchar2(4000)
    ,user_tag_ykhwm30twdlayh              varchar2(4000)
    ,user_tag_yqdawdlyh                   varchar2(4000)
    ,user_tag_j30tnscdlyh                 varchar2(4000)
    ,user_tag_jyyh                        varchar2(4000)
    ,user_tag_lsfxyh                      varchar2(4000)
    ,user_tag_glsfxyh                     varchar2(4000)
    ,user_tag_j30tahybs                   varchar2(4000)
    ,user_tag_j14tahybs                   varchar2(4000)
    ,user_tag_j7tahybs                    varchar2(4000)
    ,user_tag_csbs                        varchar2(4000)
    ,user_tag_ahyqk                       varchar2(4000)
    ,user_tag_zzywgpdjyh                  varchar2(4000)
    ,user_tag_zhglywgpdjyh                varchar2(4000)
    ,user_tag_sygpfwyh                    varchar2(4000)
    ,user_tag_cfygpfwyh                   varchar2(4000)
    ,user_tag_dkygpfwyh                   varchar2(4000)
    ,user_tag_scygpfwyh                   varchar2(4000)
    ,user_tag_wdygpfwyh                   varchar2(4000)
    ,user_tag_dlgpsbkhs                   varchar2(4000)
    ,user_tag_yctcgpkh                    varchar2(4000)
    ,user_tag_gq7tzzgnsypc                varchar2(4000)
    ,user_tag_gq30tzzgnsypc               varchar2(4000)
    ,user_tag_sjhzzphyh                   varchar2(4000)
    ,user_tag_yhzhzzphyh                  varchar2(4000)
    ,user_tag_zjlxrzzphyh                 varchar2(4000)
    ,user_tag_zzddyh                      varchar2(4000)
    ,user_tag_ssdecdcpdcs                 varchar2(4000)
    ,user_tag_ssxxccpdcs                  varchar2(4000)
    ,user_tag_ssbxcpdcs                   varchar2(4000)
    ,user_tag_ssjjdcs                     varchar2(4000)
    ,user_tag_sslccpdcs                   varchar2(4000)
    ,user_tag_j7tlcgm                     varchar2(4000)
    ,user_tag_lcgmddkh                    varchar2(4000)
    ,user_tag_lcllmgxkh                   varchar2(4000)
    ,user_tag_lcldxph                     varchar2(4000)
    ,user_tag_lcjyrkph                    varchar2(4000)
    ,user_tag_lcllwtjgmyh                 varchar2(4000)
    ,user_tag_lcgmwtjyh                   varchar2(4000)
    ,user_tag_lcgmyx                      varchar2(4000)
    ,user_tag_lllclcpsc                   varchar2(4000)
    ,user_tag_j7tckcpgm                   varchar2(4000)
    ,user_tag_ckgmddkh                    varchar2(4000)
    ,user_tag_decdcpllcs                  varchar2(4000)
    ,user_tag_decdcpgdzr                  varchar2(4000)
    ,user_tag_decdcprkph                  varchar2(4000)
    ,user_tag_decdllmgxkh                 varchar2(4000)
    ,user_tag_decdgmyx                    varchar2(4000)
    ,user_tag_xxccpllcs                   varchar2(4000)
    ,user_tag_xxccprkph                   varchar2(4000)
    ,user_tag_lhycpllcs                   varchar2(4000)
    ,user_tag_j7tjjgm                     varchar2(4000)
    ,user_tag_jjgmddkh                    varchar2(4000)
    ,user_tag_lljjlcpcs                   varchar2(4000)
    ,user_tag_lljjlcpsc                   varchar2(4000)
    ,user_tag_jjrkph                      varchar2(4000)
    ,user_tag_jjgmyx                      varchar2(4000)
    ,user_tag_j7tbxgm                     varchar2(4000)
    ,user_tag_bxgmddkh                    varchar2(4000)
    ,user_tag_llbxlcpcs                   varchar2(4000)
    ,user_tag_llbxlcpsc                   varchar2(4000)
    ,user_tag_bxrkph                      varchar2(4000)
    ,user_tag_bxgmyx                      varchar2(4000)
    ,user_tag_j7tshdxgm                   varchar2(4000)
    ,user_tag_shdxgmddkh                  varchar2(4000)
    ,user_tag_llshdxlcpcs                 varchar2(4000)
    ,user_tag_llshdxlcpsc                 varchar2(4000)
    ,user_tag_shdxrkph                    varchar2(4000)
    ,user_tag_shdxgmyx                    varchar2(4000)
    ,user_tag_j7tsftjdksq                 varchar2(4000)
    ,user_tag_dkfwpgjgpcx                 varchar2(4000)
    ,user_tag_dkrkph                      varchar2(4000)
    ,user_tag_dkllwsqyh                   varchar2(4000)
    ,user_tag_dkxqyllpc                   varchar2(4000)
    ,user_tag_sfllhd                      varchar2(4000)
    ,user_tag_sfcyhd                      varchar2(4000)
    ,user_tag_sffxhd                      varchar2(4000)
    ,user_tag_fgkq                        varchar2(4000)
    ,user_tag_kcpjykh                     varchar2(4000)
    ,user_tag_jycgcs                      varchar2(4000)
    ,user_tag_jycgzje                     varchar2(4000)
    ,user_tag_scjyjjts                    varchar2(4000)
    ,user_tag_jsyjyzdje                   varchar2(4000)
    ,user_tag_jsyjypjje                   varchar2(4000)
    ,user_tag_rfc                         varchar2(4000)
    ,user_tag_lszb1                       varchar2(4000)
    ,user_tag_lszb2                       varchar2(4000)
    ,user_tag_lszb3                       varchar2(4000)
    ,user_tag_lszb4                       varchar2(4000)
    ,user_tag_lszb5                       varchar2(4000)
    ,user_tag_lszb6                       varchar2(4000)
    ,user_tag_lszb7                       varchar2(4000)
    ,user_tag_lszb8                       varchar2(4000)
    ,user_tag_lszb9                       varchar2(4000)
    ,user_tag_lszb10                      varchar2(4000)
    ,user_tag_lszb11                      varchar2(4000)
    ,user_tag_lszb12                      varchar2(4000)
    ,user_tag_lszb13                      varchar2(4000)
    ,user_tag_lszb14                      varchar2(4000)
    ,user_tag_lszb15                      varchar2(4000)
    ,user_tag_lszb16                      varchar2(4000)
    ,user_tag_lszb17                      varchar2(4000)
    ,user_tag_lszb18                      varchar2(4000)
    ,user_tag_lszb19                      varchar2(4000)
    ,user_tag_lszb20                      varchar2(4000)
    ,etl_timestamp                        timestamp      -- 数据处理时间
)
partition by list(etl_dt)(
    partition p_19000101 values (to_date('19000101','yyyymmdd'))
)
storage (initial 1024k next 1024k)
compress ${option_switch} for query high
nologging
;

-- grant
grant select on ${idl_schema}.raws_huaxing_user_tag_data_1 to ${iel_schema};
grant select on ${idl_schema}.raws_huaxing_user_tag_data_1 to ${icl_schema};

-- comment
comment on table ${idl_schema}.raws_huaxing_user_tag_data_1 is '用户标签表';
comment on column ${idl_schema}.raws_huaxing_user_tag_data_1.etl_dt is '数据日期';
comment on column ${idl_schema}.raws_huaxing_user_tag_data_1.etl_timestamp is 'ETL处理时间戳';